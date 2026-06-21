{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mactrix";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/viktorstrate/mactrix/releases/download/v${version}/Mactrix.app.zip";
    hash = "sha256-TjVfacg9TjTB/H42JpbKuIpG/a9iGQ9Q/h1YYaZUQi8=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Mactrix.app $out/Applications/
    mkdir -p $out/bin
    makeWrapper $out/Applications/Mactrix.app/Contents/MacOS/Mactrix $out/bin/mactrix
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Native Matrix client for macOS";
    longDescription = ''
      A native macOS client for Matrix – an open protocol for decentralised, secure communications.

      Mactrix is built with Apple's SwiftUI framework to provide seamless native integration with macOS.
      It leverages the robust matrix-rust-sdk for stability and performance.
    '';
    homepage = "https://github.com/viktorstrate/mactrix";
    changelog = "https://github.com/viktorstrate/mactrix/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ deadbaed ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
