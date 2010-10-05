{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.0.2";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "1y8ydx0fcmsab31qf5id5r5fcmp3j2l8mibvbbjfy66xgxarmnpc";
  };

  buildInputs = [ kdevplatform cmake pkgconfig automoc4 shared_mime_info
    kdebase_workspace gettext stdenv.gcc.libc perl ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    description = "KDE official IDE";
    longDescription =
      ''
        A free, opensource IDE (Integrated Development Environment)
        for MS Windows, Mac OsX, Linux, Solaris and FreeBSD. It is a
        feature-full, plugin extendable IDE for C/C++ and other
        programing languages. It is based on KDevPlatform, KDE and Qt
        libraries and is under development since 1998.
      '';
    homepage = http://www.kdevelop.org;
  };
}
