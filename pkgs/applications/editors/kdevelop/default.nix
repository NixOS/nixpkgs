{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl, okteta, qjson, kate, konsole, kde_runtime, oxygen_icons }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.7.3";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "9db388d1c8274da7d168c13db612c7e94ece7815757b945b0aa0371620a06b35";
  };

  buildInputs = [ kdevplatform kdebase_workspace okteta qjson ];

  nativeBuildInputs = [ cmake pkgconfig automoc4 shared_mime_info gettext perl ];

  propagatedUserEnvPkgs = [ kdevplatform kate konsole kde_runtime oxygen_icons ];

  patches = [ ./gettext.patch ];

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
    homepage = https://www.kdevelop.org;
  };
}
