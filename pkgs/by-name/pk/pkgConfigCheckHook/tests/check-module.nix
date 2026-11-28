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
  name = "pkg-config-check-hook--check-module";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/test.pc <<EOF
    Name: test
    Description: test module
    Version: $version
    EOF

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [ "test" ];
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
