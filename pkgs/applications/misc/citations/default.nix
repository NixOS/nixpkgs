{ cargo
, darwin
, desktop-file-utils
, fetchFromGitLab
, gettext
, glib
, gtk4
, gtksourceview5
, lib
, libadwaita
, meson
, ninja
, pkg-config
, poppler
, rustPlatform
, rustc
, stdenv
, testers
, wrapGAppsHook4
, clippy
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "citations";
  version = "0.6.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-RV9oQcXzRsNcvZc/8Xt7qZ/88DvHofC2Av0ftxzeF6Q=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    libadwaita
    poppler
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  doCheck = true;

  nativeCheckInputs = [ clippy ];

  preCheck = ''
    sed -i -e '/PATH=/d' ../src/meson.build
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "citations --help";
  };

  meta = with lib; {
    description = "Manage your bibliographies using the BibTeX format";
    homepage = "https://apps.gnome.org/app/org.gnome.World.Citations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    platforms = platforms.unix;
  };
})
