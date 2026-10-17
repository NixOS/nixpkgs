# This setup hook adds every propagated lisp system to CL_SOURCE_REGISTRY

buildAsdfPath () {
    declare -A seen=()
    for dep in $propagatedBuildInputs; do
        _addToAsdfPath $dep
    done
}

addFileToSearchPathWithCustomDelimiter() {
    local delimiter="$1"
    local varName="$2"
    local file="$3"
    if [[ -f "$file" && "${!varName:+${delimiter}${!varName}${delimiter}}" \
          != *"${delimiter}${file}${delimiter}"* ]]; then
        export "${varName}=${!varName:+${!varName}${delimiter}}${file}"
    fi
}

addFileToSearchPath() {
    addFileToSearchPathWithCustomDelimiter ":" "$@"
}

_addToAsdfPath ()  {
    local dep="$1"
    if [ -v seen[$dep] ]; then
        return
    else
        seen[$dep]=1
        local path="$dep"

        # FIXME slow

        while read file; do
            case "${file##*.}" in
                jar) addFileToSearchPath "CLASSPATH" "$file" ;;
                class) addToSearchPath "CLASSPATH" "${file%/*}" ;;
                so) addToSearchPath "LD_LIBRARY_PATH" "${file%/*}" ;;
                dylib) addToSearchPath "DYLD_LIBRARY_PATH" "${file%/*}" ;;
                asd) addToSearchPath "CL_SOURCE_REGISTRY" "$path//" ;;
            esac
        done < <(find "$path" -type f,l -name '*.asd' -o -name '*.jar' \
                      -o -name '*.class' -o -name '*.so' -o -name '*.dylib')

        local prop="$dep/nix-support/propagated-build-inputs"

        if [ -e "$prop" ]; then
            local new_system
            for new_system in $(cat $prop); do
                _addToAsdfPath "$new_system"
            done
        fi
    fi
}

# addEnvHooks "$targetOffset" buildAsdfPath
