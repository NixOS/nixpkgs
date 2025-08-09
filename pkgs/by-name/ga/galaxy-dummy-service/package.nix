{
  lib,
  stdenv,
  comet-gog,
  meson,
  ninja,
  pkgsCross,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "galaxy-dummy-service";
  inherit (comet-gog) version src;
  sourceRoot = "${finalAttrs.src.name}/dummy-service";

  nativeBuildInputs = [
    meson
    ninja
    pkgsCross.mingwW64.buildPackages.gcc
  ];

  mesonFlags = [
    "--cross-file meson/x86_64-w64-mingw32.ini"
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp GalaxyCommunication.exe $out/

    runHook postInstall
  '';

  meta = {
    inherit (comet-gog.meta) changelog homepage license;
  }
  // {
    description = "Dummy Windows service for Galaxy64.dll";
    longDescription = ''
      This is a Windows executable that stubs out the "GalaxyCommunication"
      service for games that try to wake it up.  Intended for use with Comet.
    '';
    maintainers = with lib.maintainers; [ aidalgol ];
  };
})
