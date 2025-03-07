{ desktop-file-utils
, fetchFromSourcehut
, gobject-introspection
, gtk3
, lib
, libhandy
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "shipments";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "shipments";
    rev = version;
    hash = "sha256-8wX1s5mPCdMINIQP4m5q5StKqxY6CGBBxIxyQAvU7Pc=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libhandy
    (python3.withPackages (ps: with ps; [
      pygobject3
      requests
    ]))
  ];

  meta = with lib; {
    description = "Postal package tracking application";
    mainProgram = "shipments";
    homepage = "https://sr.ht/~martijnbraam/shipments/";
    changelog = "https://git.sr.ht/~martijnbraam/shipments/refs/${version}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
