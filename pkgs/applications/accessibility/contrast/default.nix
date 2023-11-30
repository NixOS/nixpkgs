{ stdenv
, lib
, fetchFromGitLab
, cairo
, cargo
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
, rustc
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "contrast";
  version = "0.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    hash = "sha256-5OFmLsP+Xk3sKJcUG/s8KwedvfS8ri+JoinliyJSmrY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8WukhoKMyApkwqPQ6KeWMsL40sMUcD4I4l7UqXf2Ld0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
    mainProgram = "contrast";
  };
}
