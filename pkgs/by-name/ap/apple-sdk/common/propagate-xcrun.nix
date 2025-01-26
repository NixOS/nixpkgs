{
  lib,
  pkgsBuildHost,
  stdenv,
  stdenvNoCC,
}:

let
  plists = import ./plists.nix {
    inherit lib stdenvNoCC;
    xcodePlatform = if stdenvNoCC.hostPlatform.isMacOS then "MacOSX" else "iPhoneOS";
  };
  inherit (pkgsBuildHost) darwin cctools xcbuild;
in
self: super: {
  propagatedNativeBuildInputs = super.propagatedNativeBuildInputs or [ ] ++ [ xcbuild.xcrun ];

  postInstall =
    super.postInstall or ""
    + ''
      specspath=$out/Library/Xcode/Specifications
      toolchainsPath=$out/Toolchains/XcodeDefault.xctoolchain
      mkdir -p "$specspath" "$toolchainsPath"

      # xcbuild expects to find things relative to the plist locations. If these are linked instead of copied,
      # it won’t find any platforms or SDKs.
      cp '${plists."Info.plist"}' "$platformPath/Info.plist"
      cp '${plists."ToolchainInfo.plist"}' "$toolchainsPath/ToolchainInfo.plist"

      for spec in '${xcbuild}/Library/Xcode/Specifications/'*; do
        ln -s "$spec" "$specspath/$(basename "$spec")"
      done
      cp '${plists."Architectures.xcspec"}' "$specspath/Architectures.xcspec"
      cp '${plists."PackageTypes.xcspec"}' "$specspath/PackageTypes.xcspec"
      cp '${plists."ProductTypes.xcspec"}' "$specspath/ProductTypes.xcspec"

      mkdir -p "$out/usr/bin"
      ln -s '${xcbuild.xcrun}/bin/xcrun' "$out/usr/bin/xcrun"
    '';
}
