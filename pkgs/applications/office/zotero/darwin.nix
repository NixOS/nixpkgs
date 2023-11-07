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
  src = fetchurl
    {
      url = "https://download.zotero.org/client/release/${version}/Zotero-${version}.dmg";
      sha256 = "sha256-ZtNMFBZ7CGp4O/xceB+2JDuPZ3FPdcuOkP8nHYIa3FE=";
    };

  dontBuild = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';
}
