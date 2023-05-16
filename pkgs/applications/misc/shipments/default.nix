{ desktop-file-utils
<<<<<<< HEAD
, fetchFromSourcehut
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gobject-introspection
, gtk3
, lib
, libhandy
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "shipments";
  version = "0.3.0";

<<<<<<< HEAD
  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "shipments";
    rev = version;
    hash = "sha256-8wX1s5mPCdMINIQP4m5q5StKqxY6CGBBxIxyQAvU7Pc=";
=======
  src = fetchurl {
    url = "https://git.sr.ht/~martijnbraam/shipments/archive/${version}.tar.gz";
    sha256 = "1znybldx21wjnb8qy6q9p52pi6lfz81743xgrnjmvjji4spwaipf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
<<<<<<< HEAD
    gobject-introspection
  ];

  buildInputs = [
=======
  ];

  buildInputs = [
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gtk3
    libhandy
    (python3.withPackages (ps: with ps; [
      pygobject3
      requests
    ]))
  ];

  meta = with lib; {
    description = "Postal package tracking application";
    homepage = "https://sr.ht/~martijnbraam/shipments/";
    changelog = "https://git.sr.ht/~martijnbraam/shipments/refs/${version}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
