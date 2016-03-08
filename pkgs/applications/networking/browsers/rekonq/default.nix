{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kde4, shared_desktop_ontologies, qca2, qoauth }:

assert builtins.compareVersions "4.8.3" kde4.release != 1; # https://bugs.kde.org/show_bug.cgi?id=306077

stdenv.mkDerivation rec {
  name = "rekonq-2.4.2"; # >=1.80 need kde >=4.9.0

  src = fetchurl {
    url = "mirror://sourceforge/rekonq/${name}.tar.xz";
    sha256 = "09jihyf4xl7bwfwahwwbx6f11h3zqljccchnpl4mijljylr5p079";
  };

  buildInputs = [ kde4.kdelibs qca2 qoauth ];

  nativeBuildInputs = [
    automoc4 cmake gettext perl pkgconfig shared_desktop_ontologies
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = https://rekonq.kde.org/;
  };
}
