{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl, okteta, qjson, kate, konsole, kde_runtime, oxygen_icons }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.7.1";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "e3ad5377f53739a67216d37cda3f88c03f8fbb0c96e2a9ef4056df3c124e95c1";
  };

  buildInputs = [ kdevplatform kdebase_workspace okteta qjson ];

  nativeBuildInputs = [ cmake pkgconfig automoc4 shared_mime_info gettext perl ];

  propagatedUserEnvPkgs = [ kdevplatform kate konsole kde_runtime oxygen_icons ];

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
