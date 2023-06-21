{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

let
  version = "1.2.13.661.ga588f749";
in
stdenv.mkDerivation {
  inherit pname version;

  src =
    if stdenv.isAarch64 then
      (
        fetchurl {
          url = "https://archive.org/download/darwin-spotify-arm64/SpotifyARM64-${version}.dmg";
          sha256 = "sha256-69JWASGgFLbQ6b6BivXHPolIMMTxwzB2rzejrnUeG+8=";
        })
    else
      (
        fetchurl {
          url = "https://archive.org/download/darwin-spotify-amd64/SpotifyAMD64-${version}.dmg";
          sha256 = "sha256-4nte4VPYHhcMG5ZWn6D6u2M43ipKFsKz4tZ2fbCom+8=";
        });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ Enzime ];
  };
}
