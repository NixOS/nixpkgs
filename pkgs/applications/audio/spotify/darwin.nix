{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.2.15.828.g79f41970";

  src = if stdenv.isAarch64 then (
    fetchurl {
      url = "https://web.archive.org/web/20230710021420/https://download.scdn.co/SpotifyARM64.dmg";
      sha256 = "sha256-1X0Mln47uYs5l1t+5BFBk5lLnXZgnSqZLX41yA91I0s=";
    })
  else (
    fetchurl {
      url = "https://web.archive.org/web/20230710021726/https://download.scdn.co/Spotify.dmg";
      sha256 = "sha256-CmKZx8Ad0w6STBN0O4Sc4XqidOM6fCl74u2sI8w+Swk=";
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
