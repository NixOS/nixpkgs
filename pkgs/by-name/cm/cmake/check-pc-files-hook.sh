cmakePcfileCheckPhase() {
    while IFS= read -rd $'\0' file; do
        grepout=$(grep --line-number '}//nix/store' "$file" || true)
        if [ -n "$grepout" ]; then
            {
            echo "Broken paths found in a .pc file! $file"
            echo "The following lines have issues (specifically '//' in paths)."
            echo "$grepout"
            echo "It is very likely that paths are being joined improperly."
            echo 'ex: "${prefix}/@CMAKE_INSTALL_LIBDIR@" should be "@CMAKE_INSTALL_FULL_LIBDIR@"'
            echo "Please see https://github.com/NixOS/nixpkgs/issues/144170 for more details."
            exit 1
            } 1>&2
        fi
    done < <(find "${!outputDev}" -iname "*.pc" -print0)
}

postFixupHooks+=(cmakePcfileCheckPhase)
