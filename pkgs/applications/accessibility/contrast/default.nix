{ stdenv
, fetchFromGitLab
, cairo
, dbus
, desktop-file-utils
, gettext
, glib
, gtk3
, libhandy
, meson
, ninja
, pango
, pkgconfig
, python3
, rustc
, rustPlatform
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "contrast";
  version = "0.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    sha256 = "0rm705zrk9rfv31pwbqxrswi5v6vhnghxa8dgxjmcrh00l8dm6j9";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "06vgc89d93fhjcyy9d1v6lf8kr34pl5bbpwbv2jpfahpj9y84bgj";

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    dbus
    glib
    gtk3
    libhandy
    pango
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  meta = with stdenv.lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = https://gitlab.gnome.org/World/design/contrast;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
  };
}

