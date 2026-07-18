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

  version = "1.2.92.147";

  # WARNING: This Wayback Machine URL redirects to the closest timestamp.
  # Future maintainers must manually check the timestamp exists and exactly matches at:
  # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
  src = fetchurl {
    url = "https://web.archive.org/web/20260607203830/https://download.scdn.co/SpotifyARM64.dmg";
    hash = "sha256-rQuvF7LWHBR3q8GJQWO671n1NRDKinQps+zYfXPktrU=";
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
