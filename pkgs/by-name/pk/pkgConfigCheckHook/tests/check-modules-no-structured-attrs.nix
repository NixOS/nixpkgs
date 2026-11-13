{
  lib,
  stdenvNoCC,
  pkgConfigCheckHook,
}:

stdenvNoCC.mkDerivation {
  # explicit pname and version are required for the hook to work but
  # name is manually set to keep drvPath consistent across
  # tests for pkgConfigCheckHook
  pname = "test";
  version = "1.0.0";
  name = "pkg-config-check-hook--check-modules-no-structured-attrs";

  strictDeps = true;
  __structuredAttrs = false;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pkgconfig $out/share/pkgconfig
    for module in xyz abc; do
      cat > $out/lib/pkgconfig/$module.pc <<EOF
    Name: $module
    Description: test module $module
    Version: $version
    EOF
    done
    cat > $out/share/pkgconfig/nix.pc <<EOF
    Name: nix
    Description: test module nix
    Version: $version
    EOF

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [
    "xyz"
    "abc"
    "nix"
  ];
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
