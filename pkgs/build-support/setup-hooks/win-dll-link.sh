fixupOutputHooks+=(_linkDLLs)

addEnvHooks "$targetOffset" linkDLLGetFolders

linkDLLGetFolders() {
    addToSearchPath "LINK_DLL_FOLDERS" "$1/lib"
    addToSearchPath "LINK_DLL_FOLDERS" "$1/bin"
}

_linkDLLs() {
    linkDLLsInfolder "$prefix/bin"
}

# Try to links every known dependency of exe/dll in the folder of the 1str input
# into said folder, so they are found on invocation.
# (DLLs are first searched in the directory of the running exe file.)
# The links are relative, so relocating whole /nix/store won't break them.
linkDLLsInfolder() {
    (
        local folder
        folder="$1"
        if [ ! -d "$folder" ]; then
            echo "Not linking DLLs in the non-existent folder $folder"
            return
        fi
        cd "$folder" || exit

        # Use associative arrays as set
        local filesToChecks
        local filesDone
        declare -A filesToChecks # files that still needs to have their dependancies checked
        declare -A filesDone     # files that had their dependancies checked and who is copied to the bin folder if found

        markFileAsDone() {
            if [ ! "${filesDone[$1]+a}" ]; then filesDone[$1]=a; fi
            if [ "${filesToChecks[$1]+a}" ]; then unset 'filesToChecks[$1]'; fi
        }

        addFileToLink() {
            if [ "${filesDone[$1]+a}" ]; then return; fi
            if [ ! "${filesToChecks[$1]+a}" ]; then filesToChecks[$1]=a; fi
        }

        # Compose path list where DLLs should be located:
        #   prefix $PATH by currently-built outputs
        local DLLPATH=""
        local outName
        for outName in $(getAllOutputNames); do
            addToSearchPath DLLPATH "${!outName}/bin"
        done
        DLLPATH="$DLLPATH:$LINK_DLL_FOLDERS"

        echo DLLPATH="'$DLLPATH'"

        for peFile in *.{exe,dll}; do
            if [ -e "./$peFile" ]; then
                addFileToLink "$peFile"
            fi
        done

        local searchPaths
        readarray -td: searchPaths < <(printf -- "%s" "$DLLPATH")

        local linkCount=0
        while [ ${#filesToChecks[*]} -gt 0 ]; do
            local listOfDlls=("${!filesToChecks[@]}")
            local file=${listOfDlls[0]}
            markFileAsDone "$file"
            if [ ! -e "./$file" ]; then
                local pathsFound
                readarray -d '' pathsFound < <(find "${searchPaths[@]}" -name "$file" -type f -print0)
                if [ ${#pathsFound[@]} -eq 0 ]; then continue; fi
                local dllPath
                dllPath="${pathsFound[0]}"
                CYGWIN+=" winsymlinks:nativestrict" ln -sr "$dllPath" .
                echo "linking $dllPath"
                file="$dllPath"
                linkCount=$((linkCount + 1))
            fi
            # local dep_file
            # Look at the file’s dependancies
            for dep_file in $($OBJDUMP -p "$file" | sed -n 's/.*DLL Name: \(.*\)/\1/p' | sort -u); do
                addFileToLink "$dep_file"
            done
        done

        echo "Created $linkCount DLL link(s) in $folder"
    )
}
