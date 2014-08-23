preFixupPhases+=" scatter_files"
preDistPhases+=" propagate_bin_input"

SCATTER_BIN_DEFAULT=${SCATTER_BIN_DEFAULT:-"/lib/*.so* /bin/*"}
SCATTER_DOC_DEFAULT=${SCATTER_DOC_DEFAULT:-"/share/man/* /share/doc/*"}


scatter_files() {
    save_nullglob=$(shopt -p nullglob)
    for o in $outputs; do
	[[ "$o" == "out" ]] && continue
	v=files_${o}
	
	#if files_'output' isn't set in derivative, use defualts for some
	[[ ${!v} ]] || {
            case $o in
		bin)
		    v=SCATTER_BIN_DEFAULT
		    ;;
		doc)
		    v=SCATTER_DOC_DEFAULT
		    ;;
		*)
		    continue
		    ;;
	    esac
        }

	# prepend each path with $out
	paths=$out${!v// \// $out/}
        shopt -s nullglob
	for f in $paths; do
	    shopt -u nullglob
	    dist=${!o}${f#$out}
	    mkdir -p $(dirname $dist)
	    cp -pr $f $dist
	    # remove source, not forgetting to clean empty dirs
	    rm -r $f
	    rmdir --ignore-fail-on-non-empty $(dirname $f)
	done
	find ${!o} -type f -exec $SHELL -c 'patchelf --set-rpath $(patchelf --print-rpath {} 2>/dev/null):'${!o}'/lib {} 2>/dev/null && patchelf --shrink-rpath {}' \;
    done
    eval $save_nullglob
}

propagate_bin_input() {
    if [[ -n ${bin:-} ]]; then
	mkdir -p $out/nix-support
	echo $bin >> $out/nix-support/propagated-native-build-inputs 
    fi

    if [[ -n ${bin:-} && -n ${doc:-} ]]; then
	mkdir -p $bin/nix-support
	echo $doc >> $bin/nix-support/propagated-user-env-packages
    fi
}
