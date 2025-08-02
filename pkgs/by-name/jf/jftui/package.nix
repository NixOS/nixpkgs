{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  curl,
  mpv,
  yajl,
}:

stdenv.mkDerivation rec {
  pname = "jftui";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = "jftui";
    rev = "v${version}";
    sha256 = "sha256-Tgiwhdo87uqVwpOvNXRdvFTfkbf9dfSNQDlGx29S2II=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    mpv
    yajl
  ];

  installPhase = ''
    install -Dm555 build/jftui $out/bin/jftui
  '';

  meta = {
    description = "Jellyfin Terminal User Interface";
    homepage = "https://github.com/Aanok/jftui";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.nyanloutre ];
    platforms = lib.platforms.linux;
    mainProgram = "jftui";
  };
}
