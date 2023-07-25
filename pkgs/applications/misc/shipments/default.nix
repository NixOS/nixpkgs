{ desktop-file-utils
, fetchurl
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

  src = fetchurl {
    url = "https://git.sr.ht/~martijnbraam/shipments/archive/${version}.tar.gz";
    sha256 = "1znybldx21wjnb8qy6q9p52pi6lfz81743xgrnjmvjji4spwaipf";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
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
