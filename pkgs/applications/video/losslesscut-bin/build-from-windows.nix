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
    7z x $src -oLosslessCut-win-x64
  '';

  sourceRoot = "LosslessCut-win-x64";

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    (cd .. && mv LosslessCut-win-x64 $out/libexec)
    ln -s "$out/libexec/LosslessCut-win-x64/LosslessCut.exe" "$out/bin/LosslessCut.exe"
  '';

  meta = metaCommon // (with lib; {
    platforms = platforms.windows;
    mainProgram = "LosslessCut.exe";
  });
}
