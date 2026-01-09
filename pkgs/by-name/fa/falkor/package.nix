{
  lib,
  stdenvNoCC,
  fetchurl,
  electron,
  dpkg,
  makeWrapper,
  commandLineArgs ? "",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "falkor";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/Team-Falkor/falkor/releases/download/v0.1.0-alpha/Falkor.deb";
    hash = "sha256-L1EBJ49+g7n6NtKs1BTBD30glL/K0SerL/k5Dl2SgqM=";
  };

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/share $out/share
    mkdir -p $out/share/falkor
    substituteInPlace $out/share/applications/falkor.desktop \
      --replace-fail "/opt/Falkor/" ""
    mv opt/Falkor/{resources,resources.pak,locales} $out/share/falkor

    makeWrapper ${lib.getExe electron} $out/bin/falkor \
      --argv0 "falkor" \
      --add-flags "$out/share/falkor/resources/app.asar" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  meta = {
    description = "Electron-based gaming hub";
    homepage = "https://github.com/Team-Falkor/falkor";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ icedborn ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "falkor";
  };
})
