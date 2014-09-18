{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl, okteta, qjson }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.7.0";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "68de8f412e8ab6107766f00623e54c458d02825e3a70f5ea9969688f8c77c120";
  };

  buildInputs = [ kdevplatform kdebase_workspace okteta qjson ];

  nativeBuildInputs = [ cmake pkgconfig automoc4 shared_mime_info gettext perl ];

  NIX_CFLAGS_COMPILE = "-I${okteta}/include/KDE";

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
