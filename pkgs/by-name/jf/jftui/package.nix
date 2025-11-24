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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = "jftui";
    rev = "v${version}";
    sha256 = "sha256-0gTJ2uXDcK9zCx6yKS3VxFyxSQZ2l4ydKUI2gYbsiao=";
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

  meta = with lib; {
    description = "Jellyfin Terminal User Interface";
    homepage = "https://github.com/Aanok/jftui";
    license = licenses.unlicense;
    maintainers = [ maintainers.nyanloutre ];
    platforms = platforms.linux;
    mainProgram = "jftui";
  };
}
