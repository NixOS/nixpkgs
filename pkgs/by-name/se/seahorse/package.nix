{ stdenv
, lib
, fetchurl
, vala
, meson
, ninja
, libpwquality
, pkg-config
, gtk3
, glib
, glib-networking
, wrapGAppsHook3
, itstool
, gnupg
, desktop-file-utils
, libsoup_3
, gnome
, gpgme
, python3
, openldap
, gcr
, libsecret
, avahi
, p11-kit
, openssh
, gsettings-desktop-schemas
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "47.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/seahorse/${lib.versions.major version}/seahorse-${version}.tar.xz";
    hash = "sha256-nBkX5KYff+u3h4Sc42znF/znBsNGiAuZHQVtVNrbysw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    itstool
    wrapGAppsHook3
    python3
    openssh
    gnupg
    desktop-file-utils
    gcr
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    gcr
    gsettings-desktop-schemas
    gpgme
    libsecret
    avahi
    libsoup_3
    p11-kit
    openldap
    libpwquality
    libhandy
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs build-aux/gpg_check_version.py
  '';

  env = lib.optionalAttrs (stdenv.cc.isGNU && (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "14")) {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=int-conversion"
      "-Wno-error=return-mismatch"
    ];
  };

  preCheck = ''
    # Add “org.gnome.crypto.pgp” GSettings schema to path
    # to make it available for “gpgme-backend” test.
    # It is used by Seahorse’s internal “common” library.
    addToSearchPath XDG_DATA_DIRS "${glib.getSchemaDataDirPath gcr}"
    # The same test also requires home directory so that it can store settings.
    export HOME=$TMPDIR
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Pick up icons from Gcr
      --prefix XDG_DATA_DIRS : "${gcr}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "seahorse";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/seahorse";
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    mainProgram = "seahorse";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
