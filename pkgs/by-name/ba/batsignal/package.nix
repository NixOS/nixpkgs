{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "batsignal";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "electrickite";
    repo = "batsignal";
    rev = version;
    sha256 = "sha256-yngd2yP6XtRp8y8ZUd0NISdf8+8wJvpLogrQQMdB0lA=";
  };

  buildInputs = [
    libnotify
    glib
  ];
  nativeBuildInputs = [ pkg-config ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/electrickite/batsignal";
    description = "Lightweight battery daemon written in C";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ SlothOfAnarchy ];
    platforms = lib.platforms.linux;
    mainProgram = "batsignal";
  };
}
