# The equivalent of patchelf but for .dylib / mach-o / shared libraries on macOS
#
# Patches the paths to shared library dependencies to use libs in the nix store.
# The script is not magical and expects the caller to provide a list of paths
# where library dependencies can be found.
#
# For example if a.dylib depended on /usr/lib/b.dylib, there's a chance the latter
# does not actually exist and can be found somewhere in /nix/store/XXX-lib/lib/b.dylib.
#
# Dependencies:
#  - grep
#  - sed (probably in the gnused package)
#
# Arguments:
#  1. targetLib: path to a shared library that has to be patched
#  2. libraryPaths: <colon> (:) separated list of paths
function patchDylib(){
  local targetLib="$1"
  local libraryPaths="$2"

  # Make the shared paths absolute
  install_name_tool -id $targetLib $targetLib
  # Get all dependent shared libs
  libs="$(otool -L $targetLib \
          | sed --regexp-extended \
                --expression='s|^\s+(.+)\s\(.+\)|\1|g' \
          | grep --extended-regexp \
                 --invert-match '^(/nix/store|/System)'
        )"

  for libDep in $libs ; do
    # Get the name of a lib dependency from an absolute path like /usr/lib/abc.dylib
    libName=$(echo "$libDep" \
        | sed --regexp-extended \
              --expression='s|/.+/(.+)$|\1|g'
    )
    libInNix=$(findFile $libName "$libraryPaths")
    if [[ -n "$libInNix" ]]
    then
      echo "Changing dep from '$libDep' to '$libInNix'"
      install_name_tool -change "$libDep" "$libInNix" $targetLib
    fi
  done

}

# Finds a file in given list directories
function findFile(){
  local file="$1"
  local paths="$(echo "$2" | sed -e "s|:|\n|g")"
  for path in $paths
  do
    if [[ -e "$path/$file" ]]
    then
      echo "$path/$file"
      break
    fi
  done
}
