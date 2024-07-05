{ lib
, stdenvNoCC
, fetchurl
, p7zip
, pname
, version
, hash
, metaCommon ? { }
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-win-x64.7z";
    inherit hash;
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    runHook preUnpack
    7z x "$src" -o"$sourceRoot"
    runHook postUnpack
  '';

  sourceRoot = "LosslessCut-win-x64";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/libexec"
    cd ..
    mv "$sourceRoot" "$out/libexec"
    ln -s "$out/libexec/$(basename "$sourceRoot")/LosslessCut.exe" "$out/bin/LosslessCut.exe"
    runHook postInstall
  '';

  meta = metaCommon // (with lib; {
    platforms = platforms.windows;
    mainProgram = "LosslessCut.exe";
  });
}
