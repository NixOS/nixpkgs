{ stdenv, fetchurl, extra-cmake-modules, kdoctools, qtscript, kconfig
, kinit, karchive, kcrash, kcmutils, kconfigwidgets, knewstuff, kparts
, qca-qt5, shared-mime-info }:

stdenv.mkDerivation rec {
  name = "okteta-${version}";
  version = "0.25.2";

  src = fetchurl {
    url = "mirror://kde/stable/okteta/${version}/src/${name}.tar.xz";
    sha256 = "00mw8gdqvn6vn6ir6kqnp7xi3lpn6iyp4f5aknxwq6mdcxgjmh1p";
  };

  nativeBuildInputs = [ qtscript extra-cmake-modules kdoctools ];
  buildInputs = [ shared-mime-info ];

  propagatedBuildInputs = [
    kconfig
    kinit
    kcmutils
    kconfigwidgets
    knewstuff
    kparts
    qca-qt5
    karchive
    kcrash
  ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg bkchr ];
    platforms = platforms.linux;
  };
}
