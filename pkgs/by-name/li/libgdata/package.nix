{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, nixosTests
, vala
, gettext
, libxml2
, glib
, json-glib
, gcr
, gnome-online-accounts
, gobject-introspection
, gnome
, p11-kit
, openssl
, uhttpmock
, libsoup_2_4
}:

stdenv.mkDerivation rec {
  pname = "libgdata";
  version = "0.18.1";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "3YWS7rZRKtCoz1yL6McudvdL/msj5N2T8HVu4HFoBMc=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gcr
    openssl
    p11-kit
    uhttpmock
  ];

  propagatedBuildInputs = [
    glib
    libsoup_2_4
    libxml2
    gnome-online-accounts
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dinstalled_test_bindir=${placeholder "installedTests"}/libexec"
    "-Dinstalled_test_datadir=${placeholder "installedTests"}/share"
    "-Dinstalled_tests=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none"; # Stable version has not been updated for a long time.
    };

    tests = {
      installedTests = nixosTests.installed-tests.libgdata;
    };
  };

  meta = with lib; {
    description = "GData API library";
    homepage = "https://gitlab.gnome.org/GNOME/libgdata";
    maintainers = with maintainers; [ raskin ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
