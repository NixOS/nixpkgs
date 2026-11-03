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
  name = "pkg-config-check-hook--dont-check-version";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  # module version intentionally differs from $version
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/test.pc <<EOF
    Name: test
    Description: test module
    Version: 1.0
    EOF

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [ "test" ];
  dontPkgConfigCheckVersion = true;
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
