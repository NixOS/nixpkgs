{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    tag = "v${version}";
    hash = "sha256-si/6iZMipfm18lrwjJvuL+vQco0l+HresUEv2gj1uRw=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r . $out/
    runHook postInstall;
  '';

  meta = with lib; {
    description = "Yet another web front-end for rTorrent";
    homepage = "https://github.com/Novik/ruTorrent";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
