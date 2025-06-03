{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  libxml2,
  deadbeef,
  glib,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "deadbeef-headerbar-gtk3-plugin";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "ddb_misc_headerbar_GTK3";
    rev = "v${version}";
    sha256 = "1v1schvnps7ypjqgcbqi74a45w8r2gbhrawz7filym22h1qr9wn0";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    libxml2
  ];
  buildInputs = [
    deadbeef
    glib
    gtk3
  ];

  # Choose correct installation path
  # https://github.com/saivert/ddb_misc_headerbar_GTK3/commit/50ff75f76aa9d40761e352311670a894bfcd5cf6#r30319680
  makeFlags = [ "pkglibdir=$(out)/lib/deadbeef" ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "Plug-in that adds GTK 3 header bar to the DeaDBeeF music player";
    homepage = "https://github.com/saivert/ddb_misc_headerbar_GTK3";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
