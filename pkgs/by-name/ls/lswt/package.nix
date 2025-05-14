{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  wayland-scanner,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "lswt";
  version = "2.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "lswt";
    rev = "v${version}";
    hash = "sha256-8jP6I2zsDt57STtuq4F9mcsckrjvaCE5lavqKTjhNT0=";
  };

  patches = [
    # Subject: [PATCH] fix JSON formatting of identifier string
    (fetchpatch {
      url = "https://git.sr.ht/~leon_plickat/lswt/commit/d35786da4383388c19f5437128fd393a6f16f74f.patch";
      hash = "sha256-3RTq8BXRR7MgKV0BueoOjPORMrYVAKNbKR74hZ75W/Y=";
    })
  ];

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
