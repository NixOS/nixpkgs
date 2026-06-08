{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  curl,
  mpv,
  yajl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jftui";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = "jftui";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Jellyfin Terminal User Interface";
    homepage = "https://github.com/Aanok/jftui";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.nyanloutre ];
    platforms = lib.platforms.linux;
    mainProgram = "jftui";
  };
})
