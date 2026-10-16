{
  stdenv,
  pname,
  meta,
  fetchurl,
  undmg,
  updateScript,
  lib,
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.3.5.3058";

  # WARNING: This Wayback Machine URL redirects to the closest timestamp.
  # Future maintainers must manually check the timestamp exists and exactly matches at:
  # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
  src = fetchurl {
    url = "https://web.archive.org/web/20261016020434/https://download.scdn.co/SpotifyARM64.dmg";
    hash = "sha256-27fDkGdfwDIhRsgfJjp5yUgkSqou8K/h4PSvdtphDL0=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru = { inherit updateScript; };

  meta = meta // {
    maintainers = with lib.maintainers; [
      matteopacini
      Enzime
    ];
  };
}
