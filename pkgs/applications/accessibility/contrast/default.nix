{ stdenv
, lib
, fetchFromGitLab
, cairo
, desktop-file-utils
, gettext
, glib
, gtk4
, libadwaita
, meson
, ninja
, pango
, pkg-config
, rustPlatform
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "contrast";
  version = "0.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    hash = "sha256-waoXv8dzqynkpfEPZSgZnS6fyo9+9+3Q2oy2fMtEsoE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-94QwPSiGjjPuskg5w6QfM5FuChFno7f9dh0Xr2wWKCI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    glib
    gtk4
    libadwaita
    pango
  ];

  meta = with lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
