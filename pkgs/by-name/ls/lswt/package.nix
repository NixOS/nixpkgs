{
  lib,
  stdenv,
  fetchFromSourcehut,
  wayland-scanner,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "lswt";
  version = "2.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8jP6I2zsDt57STtuq4F9mcsckrjvaCE5lavqKTjhNT0=";
  };

  nativeBuildInputs = [ wayland-scanner ];
  buildInputs = [ wayland ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Command that lists Wayland toplevels";
    homepage = "https://sr.ht/~leon_plickat/lswt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edrex ];
    platforms = platforms.linux;
    mainProgram = "lswt";
  };
}
