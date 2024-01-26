{ lib
, stdenv
, fetchurl
, undmg
, pname
, version
, meta
}:


stdenv.mkDerivation {
  inherit pname version meta;
  src =
    if stdenv.isAarch64 then
      fetchurl
        {
          url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-darwin-arm64-${version}.dmg";
          hash = "sha256-FB8jSo+p3Spj0k4qQgoVW8i1aSs/XwGM/2SjxAiLTRY=";
        }
    else
      fetchurl
        {
          url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-darwin-x64-${version}.dmg";
          sha256 = "sha256-al8kmxkmrjkyxs9ntPtGu/Bf1jPz6emW1LMbHWiYYec=";
        };


  dontBuild = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';
}
