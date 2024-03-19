{ lib
, cargo
, desktop-file-utils
, fetchFromGitLab
, glib
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "lorem";
  version = "1.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = pname;
    rev = version;
    hash = "sha256-+Dp/o1rZSHWihLLLe6CzV6c7uUnSsE8Ct3tbLNqlGF0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-YYjPhlPp211i+ECPu1xgDumz8nVqWRO8YzcZXy8uunI=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Generate placeholder text";
    homepage = "https://gitlab.gnome.org/World/design/lorem";
    changelog = "https://gitlab.gnome.org/World/design/lorem/-/releases/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ michaelgrahamevans ];
    mainProgram = "lorem";
    platforms = platforms.linux;
  };
}
