{ lib, stdenv, fetchurl, pkg-config, meson, ninja, makeFontsConf, vala, fetchpatch
, gnome, libgee, glib, json-glib, libarchive, libsoup, gobject-introspection }:

let
  pname = "libhttpseverywhere";
  version = "0.8.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1jmn6i4vsm89q1axlq4ajqkzqmlmjaml9xhw3h9jnal46db6y00w";
  };

  nativeBuildInputs = [ vala gobject-introspection meson ninja pkg-config ];
  buildInputs = [ glib libgee json-glib libsoup libarchive ];

  patches = [
    # Fixes build with vala >=0.42
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libhttpseverywhere/commit/6da08ef1ade9ea267cecf14dd5cb2c3e6e5e50cb.patch";
      sha256 = "1nwjlh8iqgjayccwdh0fbpq2g1h8bg1k1g9i324f2bhhvyhmpq8f";
    })
    # fix build with meson 0.60
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libhttpseverywhere/-/commit/4c38b2ca25802c464f3204a62815201d8cf549fd.patch";
      sha256 = "sha256-1+fmR0bpvJ9ISN2Hr+BTIQz+Bf6VfY1RdVZ/OohUlWU=";
    })
  ];

  mesonFlags = [ "-Denable_valadoc=true" ];

  doCheck = true;

  checkPhase = "(cd test && ./httpseverywhere_test)";

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  outputs = [ "out" "devdoc" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library to use HTTPSEverywhere in desktop applications";
    homepage = "https://gitlab.gnome.org/GNOME/libhttpseverywhere";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ] ++ teams.gnome.members;
  };
}
