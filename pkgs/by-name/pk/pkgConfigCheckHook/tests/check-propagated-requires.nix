{
  lib,
  stdenvNoCC,
  pkgConfigCheckHook,
}:

let
  dep = stdenvNoCC.mkDerivation {
    pname = "dep";
    version = "1.0.0";
    name = "pkg-config-check-hook--check-propagated-requires-dep";

    strictDeps = true;
    __structuredAttrs = true;

    src = null;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/pkgconfig
      cat > $out/lib/pkgconfig/dep.pc <<EOF
      Name: dep
      Description: propagated dependency
      Version: $version
      EOF

      runHook postInstall
    '';

    nativeInstallCheckInputs = [ pkgConfigCheckHook ];
    pkgConfigModules = [ "dep" ];
    doInstallCheck = true;

    meta.platforms = lib.platforms.all;
  };
in
stdenvNoCC.mkDerivation {
  # explicit pname and version are required for the hook to work but
  # name is manually set to keep drvPath consistent across
  # tests for pkgConfigCheckHook
  pname = "test";
  version = "1.0.0";
  name = "pkg-config-check-hook--check-propagated-requires";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  # the module's Requires is only resolvable through pkg-config's setup
  # hook, which the check hook must propagate
  propagatedBuildInputs = [ dep ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/test.pc <<EOF
    Name: test
    Description: test module
    Version: $version
    Requires: dep
    EOF

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [ "test" ];
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
