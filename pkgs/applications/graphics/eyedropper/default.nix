{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, meson
, ninja
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "eyedropper";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = version;
    hash = "sha256-dOB274OA7h1vwCuapzivHnMLLw/NTzsmOfFtHHaca1I=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ymRl/nIUuT1BXa1dF5CMemBI8aYrdqeoVtghm6NF8cs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "An easy-to-use color picker and editor";
    homepage = "https://github.com/FineFindus/eyedropper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
