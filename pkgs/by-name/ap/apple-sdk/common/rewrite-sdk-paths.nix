{ lib, sdkVersion }:

let
  name = "MacOSX${lib.versions.majorMinor sdkVersion}.sdk";
in
self: super: {
  # Rewrite the stubs to point to dylibs in the SDK instead of at system locations. This is needed for umbrella
  # frameworks in older SDKs, which don’t also embed their stubs.
  buildPhase =
    super.buildPhase or ""
    + ''
      echo "Rewriting stubs to reference the SDK location in the store"
      find . -name '*.tbd' -type f -exec sed -E \
        -e "/^install-name/n; s|( \\|'\\|\"\\|\\[)/usr/|\1$sdkpath/${name}/usr/|g" \
        -e "/^install-name/n; s|( \\|'\\|\"\\|\\[)/System/|\1$sdkpath/${name}/System/|g" \
        -i {} \;
    '';
}
