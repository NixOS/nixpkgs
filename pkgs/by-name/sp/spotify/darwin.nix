{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.2.40.599.g606b7f29";

  src = if stdenv.hostPlatform.isAarch64 then (
    fetchurl {
      url = "https://web.archive.org/web/20240622065234/https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-mmjxKYmsX0rFlIU19JOfPbNgOhlcZs5slLUhDhlON1c=";
    })
  else (
    fetchurl {
      url = "https://web.archive.org/web/20240622065548/https://download.scdn.co/Spotify.dmg";
      hash = "sha256-hvS0xnmJQoQfNJRFsLBQk8AJjDOzDy+OGwNOq5Ms/O0=";
    });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ matteopacini ];
  };
}
