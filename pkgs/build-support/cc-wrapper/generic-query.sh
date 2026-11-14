# Driver diagnostics quote job arguments for display. Decode their quoting,
# without executing shell syntax from a compiler, a specs file, or a filename.
wrapperReadJob() {
    local text=$1 char quote='' escape=0 word='' started=0 i
    wrapperJob=()
    for ((i=0; i<${#text}; ++i)); do
        char=${text:i:1}
        if ((escape)); then
            word+=$char; escape=0; started=1
        elif [[ $char == \\ && $quote != "'" ]]; then
            escape=1; started=1
        elif [[ -n $quote ]]; then
            if [[ $char == "$quote" ]]; then quote=; else word+=$char; fi
        elif [[ $char == '"' || $char == "'" ]]; then
            quote=$char; started=1
        elif [[ $char == ' ' || $char == $'\t' ]]; then
            if ((started)); then wrapperJob+=("$word"); word=; started=0; fi
        else
            word+=$char; started=1
        fi
    done
    [[ -z $quote && $escape == 0 ]] || return 1
    if ((started)); then wrapperJob+=("$word"); fi
}

# Known driver operands that are opaque to linker selection and filtering.
# This is shared by those scans, not a replacement for the native parser.
compilerOptionTakesOperand() {
    case "$1" in
        -o|--output|-x|-include|-imacros|-I|-L|-isystem|-idirafter|-iquote|-isysroot|--sysroot|-B|\
        -target|--target|-arch|-Xclang|-Xassembler|-Xpreprocessor|-Xcuda-fatbinary|-Xcuda-ptxas|\
        -MF|-MT|-MQ|-dumpbase|-dumpbase-ext|-dumpdir|-auxbase|-auxbase-strip|\
        -u|-T|-D|-U|--config|-resource-dir|-working-directory|-F|-iframework) return 0 ;;
        *) return 1 ;;
    esac
}

# Compile/link policy can forward linker options in either driver spelling.
# Decode losslessly, filter each native linker-input stream, then render the
# surviving entries in their original driver order. Caller argv is not input.
filterCompilerRpathFlags() {
    local linkType=$1 arg value scope stream style path i j operand removeOperand terminated=0
    shift
    if [[ $linkType != static-pie ]]; then printf '%s\n' "$*"; return; fi
    local -a values=() scopes=() styles=() streams=() keep=() forwarded=() result=()
    while (($#)); do
        arg=$1; shift
        scope='' stream=ordinary style=raw
        if [[ $arg == -Xarch_* ]]; then
            scope=$arg
            if (($#)); then arg=$1; shift
            else arg=$scope; scope=''; stream=opaque
            fi
            # An ignored architecture/device argument is one opaque carrier.
            # It cannot consume an operand from either host linker stream.
            if [[ $scope == -Xarch_device ||
                  ( -n $scope && $scope != -Xarch_host && $scope != "-Xarch_${wrapperHostArch:-}" ) ]]; then
                stream=opaque
            elif [[ -n $scope ]]; then
                stream=scoped
            fi
        fi
        forwarded=("$arg")
        if [[ $stream != opaque ]] && compilerOptionTakesOperand "$arg"; then
            stream=opaque
            if [[ -z $scope ]] && (($#)); then forwarded+=("$1"); shift; fi
        fi
        if [[ $stream != opaque ]]; then
            case "$arg" in
                --)
                    stream=opaque
                    if [[ -z $scope ]]; then forwarded+=("$@"); set --; fi ;;
                -Wl,*)
                    style=wl; forwarded=(); value=${arg#-Wl,}
                    # read -a drops trailing empty fields, which are real
                    # operands in -Wl,-rpath, and must remain distinguishable.
                    while [[ $value == *,* ]]; do
                        forwarded+=("${value%%,*}"); value=${value#*,}
                    done
                    forwarded+=("$value") ;;
                -l)
                    if [[ -z $scope ]] && (($#)); then
                        forwarded=("-l$1"); shift
                    else stream=opaque
                    fi ;;
                -l?*)
                    # Clang's scoped LinkerInput lowering uses the option's
                    # value, whereas an ordinary library renders as -lVALUE.
                    if [[ -n $scope ]]; then style=library; forwarded=("${arg#-l}"); fi ;;
                -z|-e|-framework|-weak_framework)
                    # Render each lowered token independently: a preceding
                    # linker option may consume this option as its operand.
                    if [[ -z $scope ]] && (($#)); then
                        if [[ "@isGNU@" == 1 ]]; then stream=opaque
                        else style=wl; fi
                        forwarded+=("$1"); shift
                    else stream=opaque
                    fi ;;
                -r|--no-undefined) ;;
                -Xlinker)
                    if [[ -z $scope ]] && (($#)); then
                        style=xlinker; forwarded=("$1"); shift
                    else
                        # A scoped argument cannot consume another driver
                        # argument. Preserve the original native diagnostic.
                        stream=opaque
                    fi ;;
                -rpath|--rpath|-R|--just-symbols|-just-symbols)
                    if [[ -n $scope ]]; then stream=opaque
                    elif (($#)); then forwarded+=("$1"); shift
                    fi ;;
                -rpath=*|--rpath=*|-R?*|--just-symbols=*|-just-symbols=*) ;;
                @*) stream=opaque ;;
                *)
                    # An ordinary input is also a linker operand, even when
                    # the driver produces an object for it before linking.
                    if [[ -n $scope || ( $arg == -* && $arg != - ) ]]; then stream=opaque; fi ;;
            esac
        fi
        for value in "${forwarded[@]}"; do
            values+=("$value"); scopes+=("$scope"); styles+=("$style")
            streams+=("$stream"); keep+=(1)
        done
    done
    # Clang lowers scoped LinkerInput arguments through Zlinker_input before
    # ordinary inputs. Their operands must not be confused with ordinary -Wl
    # arguments, regardless of the interleaving in the original driver argv.
    for stream in scoped ordinary; do
        (( !terminated )) || break
        operand=0 removeOperand=0
        for ((i=0; i<${#values[@]}; ++i)); do
            [[ ${streams[i]} == "$stream" ]] || continue
            if ((operand)); then
                keep[i]=$((1-removeOperand)); operand=0; removeOperand=0
                continue
            fi
            value=${values[i]}
            case "$value" in
                --) terminated=1; break ;;
                -rpath|--rpath) keep[i]=0; operand=1; removeOperand=1 ;;
                -rpath=*|--rpath=*) keep[i]=0 ;;
                -R|--just-symbols|-just-symbols)
                    # Inspect only the next argument in this destination,
                    # retaining existing symbol files and missing-file errors.
                    for ((j=i+1; j<${#values[@]}; ++j)); do
                        [[ ${streams[j]} == "$stream" ]] || continue
                        if linkerJustSymbolsIsRpath "${values[j]}" "$value"; then
                            keep[i]=0; removeOperand=1
                        fi
                        break
                    done
                    operand=1 ;;
                -R?*|--just-symbols=*|-just-symbols=*)
                    case "$value" in -R*) path=${value:2} ;; *) path=${value#*=} ;; esac
                    if linkerJustSymbolsIsRpath "$path" "$value"; then keep[i]=0; fi ;;
                *) if linkerOptionTakesOperand "$value"; then operand=1; fi ;;
            esac
        done
    done
    for ((i=0; i<${#values[@]}; ++i)); do
        ((keep[i])) || continue
        if [[ -n ${scopes[i]} ]]; then result+=("${scopes[i]}"); fi
        case "${styles[i]}" in
            wl) result+=("-Wl,${values[i]}") ;;
            xlinker) result+=(-Xlinker "${values[i]}") ;;
            library) result+=("-l${values[i]}") ;;
            raw) result+=("${values[i]}") ;;
        esac
    done
    printf '%s\n' "${result[*]}"
}

# Ask GCC/Clang to expand specs/configs and print, but never run, their jobs.
# The native protocol is retained when available, so response files and the
# selected target use exactly the same grammar as the eventual invocation.
# Unknown drivers and unsuccessful observations retain the compatibility scan.
wrapperObserveLinkType() {
    local directory cleanup status=0 line jobText='' jobRecord=0 executable arg candidate=0 inputFD outputFD
    local selectedFlavor="@bintools_isLLVM@" prefix nextPrefix=0 selectorOperand=0 jobOperand
    local collect2Major=unknown
    local -a queryBefore=("${extraBefore[@]}" -###)
    local -a queryAfter=("${extraAfter[@]}" $wrapperCFlagsLink) linkerJob
    wrapperHostArch=''
    # This Clang debugging hook can remove -### and execute the jobs. Keep its
    # native execution semantics, but do not invoke it speculatively.
    if [[ $nativePrimaryQuery == 0 && "@isClang@" == 1 && -n ${CCC_OVERRIDE_OPTIONS:-} ]]; then
        return 0
    fi
    for arg in $wrapper_NIX_LDFLAGS_BEFORE; do
        queryBefore+=("-Wl,$arg")
    done
    # A custom executable search prefix can change collect2's linker without
    # naming that linker in its printed argv. Do not guess its -R semantics.
    for arg in "${queryBefore[@]}" "${params[@]}" "${queryAfter[@]}"; do
        if ((selectorOperand)); then selectorOperand=0; continue; fi
        if (( !nextPrefix )); then
            case "$arg" in
            --) break ;;
            -Xlinker|-l|-z|-e|-framework|-weak_framework|-Xarch_*)
                # These are driver operands, not linker-selection options.
                selectorOperand=1; continue ;;
            esac
            # -B is handled below as an executable search prefix.
            if [[ $arg != -B ]] && compilerOptionTakesOperand "$arg"; then
                selectorOperand=1; continue
            fi
        fi
        prefix=''
        if ((nextPrefix)); then prefix=$arg; nextPrefix=0
        else
            case "$arg" in
                -B) nextPrefix=1 ;;
                -B?*) prefix=${arg:2} ;;
            esac
        fi
        if [[ -n $prefix ]]; then
            case "$prefix" in
                @bintools@/bin|@bintools@/bin/|@bintools_raw@/bin|@bintools_raw@/bin/) ;;
                *)
                    for executable in "$prefix"ld "$prefix"/ld "$prefix"/*-ld "$prefix"/ld.*; do
                        if [[ -x $executable ]]; then selectedFlavor=unknown; break; fi
                    done ;;
            esac
            continue
        fi
        case "$arg" in
            -fuse-ld=lld|-fuse-ld=*/ld.lld|--ld-path=*/ld.lld) selectedFlavor=1 ;;
            -fuse-ld=bfd|-fuse-ld=gold|-fuse-ld=*/ld.bfd|-fuse-ld=*/ld.gold) selectedFlavor=0 ;;
            -fuse-ld=*|--ld-path=*) selectedFlavor=unknown ;;
        esac
    done
    # A refinement observes the rendering selected by the first native job.
    # Keep this choice for execution even if specs select yet another linker;
    # observation must describe emitted arguments, not seek a fixed point.
    if (( $# )); then selectedFlavor=$1; fi
    wrapperLinkerRenderIsLLVM=$selectedFlavor
    wrapperLinkerIsLLVM=$selectedFlavor
    wrapperCompilerLinkerFlags "$wrapperLinkerRenderIsLLVM" $wrapper_NIX_LDFLAGS
    local -a queryMain=("${wrapperLinkerFlags[@]}")
    queryAfter+=("${wrapperLinkerFlags[@]}")
    if [[ $nativePrimaryQuery == 0 && "@isGNU@" == 1 ]]; then
        # Older GNU drivers have no suppressed observation entry. Do not
        # repeat known immediate diagnostic/truncation effects in that tier.
        [[ -z ${GCC_DIAGNOSTICS_LOG:-} ]] || return 0
        for arg in "${queryBefore[@]}" "${params[@]}" "${queryAfter[@]}"; do
            case "$arg" in
                -truncate|-truncate=*|-time|-time=*|-fdiagnostics-add-output=*|-fdiagnostics-set-output=*|\
                -fdiagnostics-format=json-file|-fdiagnostics-format=sarif-file|@*) return 0 ;;
            esac
        done
    fi
    directory=$(@mktemp@ -d "${TMPDIR:-/tmp}/cc-jobs.XXXXXXXX")
    printf -v cleanup '@rm@ -rf -- %q; trap - EXIT RETURN' "$directory"
    trap "$cleanup" EXIT RETURN
    if [[ $nativePrimaryQuery == 1 ]]; then
        local -a primaryBefore=("${queryBefore[@]}") primaryAfter=("${queryAfter[@]}") primaryCPP=()
        wrapperWriteNativeFrame > "$directory/request"
        exec {inputFD}< "$directory/request"
        exec {outputFD}> "$directory/result"
        NIX_CC_PRIMARY_ARGS_FD=$inputFD NIX_CC_PRIMARY_QUERY_FD=$outputFD \
            NIX_CC_PRIMARY_TMPDIR=$directory NIX_CC_PRIMARY_SHOW_JOBS=1 \
            PATH=$path_backup "$wrapperCompiler" \
            > /dev/null 2> "$directory/jobs" || status=$?
        exec {inputFD}<&-
        exec {outputFD}>&-
    else
        # Clang removes the selected compilation database and opens its
        # serialized diagnostics during driver construction, even with -###.
        # Redirect those immediate outputs into the private query directory.
        # An unsupported driver mode conservatively fails this observation.
        if [[ "@isClang@" == 1 ]]; then
            queryAfter+=("-MJ$directory/compilation.json" -serialize-diagnostics "$directory/diagnostics" -Qunused-arguments)
        fi
        if ((${#positionalArgs[@]})); then queryAfter+=(-- "${positionalArgs[@]}"); fi
        PATH=$path_backup "$wrapperCompiler" "${queryBefore[@]}" "${params[@]}" \
            "${queryAfter[@]}" \
            > /dev/null 2> "$directory/jobs" || status=$?
    fi
    if ((status == 0)); then
        while IFS= read -r line; do
            if [[ -n $jobText ]]; then
                jobText+=$'\n'$line
            else
                if [[ $line =~ ^gcc\ version\ ([0-9]+)\. ]]; then
                    collect2Major=${BASH_REMATCH[1]}
                    continue
                fi
                if [[ $line == 'Target: '* ]]; then
                    wrapperHostArch=${line#Target: }; wrapperHostArch=${wrapperHostArch%%-*}
                    continue
                fi
                jobRecord=0
                if [[ $line == ' '* || $line == $'\t'* ]]; then jobRecord=1
                elif [[ $line != COLLECT_GCC_OPTIONS=* ]]; then continue
                fi
                jobText=$line
            fi
            # Jobs and GCC's quoted option summaries can contain literal
            # newlines. Finish the record before considering another line.
            wrapperReadJob "$jobText" || continue
            jobText=''
            ((jobRecord)) || continue
            ((${#wrapperJob[@]})) || continue
            executable=${wrapperJob[0]##*/}
            candidate=0
            case "$executable" in
                collect2|ld|ld.*|*-ld|*-ld.*|lld|lld-link|link.exe) candidate=1 ;;
            esac
            # Explicit linker paths may have arbitrary basenames. Only accept
            # a custom job when it has linker-specific arguments; never cc1.
            for arg in "${wrapperJob[@]:1}"; do
                case "$arg" in
                    -cc1|-cc1as) candidate=0; break ;;
                    --no-dynamic-linker|--dynamic-linker*|-dynamic-linker*|-Bstatic|-static|-shared|-pie) candidate=1 ;;
                esac
            done
            case "$executable" in cc1|cc1plus|cc1obj|cc1objplus|f951) candidate=0 ;; esac
            if ((candidate)); then
                case "$executable" in
                    ld.lld|lld|lld-link|*-ld.lld) wrapperLinkerIsLLVM=1 ;;
                    ld.bfd|ld.gold|*-ld.bfd|*-ld.gold) wrapperLinkerIsLLVM=0 ;;
                    collect2) wrapperLinkerIsLLVM=$selectedFlavor ;;
                    ld|*-ld)
                        case "${wrapperJob[0]}" in
                            @bintools@/bin/*|@bintools_raw@/bin/*) wrapperLinkerIsLLVM=@bintools_isLLVM@ ;;
                            *) wrapperLinkerIsLLVM=unknown ;;
                        esac ;;
                    *) wrapperLinkerIsLLVM=unknown ;;
                esac
                jobOperand=0
                for arg in "${wrapperJob[@]:1}"; do
                    if ((jobOperand)); then jobOperand=0; continue; fi
                    # GCC 9+ collect2's early scan skips -o's operand;
                    # other jobs already use the final linker's grammar.
                    if [[ $executable == collect2 ]]; then
                        if [[ $arg == -o && ( $collect2Major == unknown || $collect2Major -ge 9 ) ]]; then
                            jobOperand=1; continue
                        fi
                    elif linkerOptionTakesOperand "$arg"; then jobOperand=1; continue
                    fi
                    if [[ $executable == collect2 ]]; then
                        # collect2 recognizes exact names, not --ld-path or
                        # absolute -fuse-ld paths. GCC 8 predates LLD support.
                        case "$arg" in
                            -fuse-ld=bfd|-fuse-ld=gold) wrapperLinkerIsLLVM=0 ;;
                            -fuse-ld=lld)
                                if [[ $collect2Major == unknown || $collect2Major -ge 9 ]]; then
                                    wrapperLinkerIsLLVM=1
                                fi ;;
                            -fuse-ld=mold|-fuse-ld=wild) wrapperLinkerIsLLVM=unknown ;;
                        esac
                        continue
                    fi
                    case "$arg" in
                        -fuse-ld=lld|-fuse-ld=*/ld.lld|--ld-path=*/ld.lld) wrapperLinkerIsLLVM=1 ;;
                        -fuse-ld=bfd|-fuse-ld=gold|-fuse-ld=*/ld.bfd|-fuse-ld=*/ld.gold) wrapperLinkerIsLLVM=0 ;;
                        -fuse-ld=*|--ld-path=*) wrapperLinkerIsLLVM=unknown ;;
                    esac
                done
                linkerJob=("${wrapperJob[@]:1}")
                if [[ $executable == collect2 ]]; then
                    # collect2 consumes its private options before ld sees
                    # the remaining stream, even inside most ld operands.
                    # Its lowering scan preserves -o/-dynamic-linker operands.
                    linkerJob=() jobOperand=0
                    for arg in "${wrapperJob[@]:1}"; do
                        if ((jobOperand)); then
                            linkerJob+=("$arg"); jobOperand=0
                            continue
                        fi
                        case "$arg" in
                            -o|-dynamic-linker) linkerJob+=("$arg"); jobOperand=1 ;;
                            -fuse-ld=*|-flto*|-fno-lto*|-debug) ;;
                            *) linkerJob+=("$arg") ;;
                        esac
                    done
                fi
                linkType=$(checkLinkerLinkType "${linkerJob[@]}")
            fi
        done < "$directory/jobs"
    fi
    @rm@ -rf -- "$directory"
    trap - EXIT RETURN
    if (( $# == 0 && status == 0 )); then
        wrapperCompilerLinkerFlags "$wrapperLinkerIsLLVM" $wrapper_NIX_LDFLAGS
        # Rendering preserves token count; only the -Wl prefix can differ.
        # Retry only when native linker discovery changes those arguments.
        if [[ ${wrapperLinkerFlags[*]} != "${queryMain[*]}" ]]; then
            wrapperObserveLinkType "$wrapperLinkerIsLLVM"
        fi
    fi
}
