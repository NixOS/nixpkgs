{
  lib,
  stdenv,
  fetchFromGitHub,
  symlinkJoin,
  acl,
  avahi,
  bison,
  cmark-gfm,
  db53,
  dbus,
  glib,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  file,
  flex,
  libevent,
  libgcrypt,
  localsearch,
  meson,
  ninja,
  perl,
  openssl,
  pam,
  pkg-config,
  tinysparql,
  libxslt,
  talloc,
  cups,
  libkrb5,
}:

let db53Combined = 
    symlinkJoin {name = "db53Combined"; paths = [ db53.out db53.dev ];};
in

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Netatalk";
    repo = "netatalk";
    rev = "netatalk-${builtins.replaceStrings ["."] ["-"] finalAttrs.version}";
    # tags are 'netatalk-4-1-0'
    hash = "sha256-+ger7c2ixkTI6i0qn/KiWDZA4kYrhkaL7Wr79ctgkH4=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace /usr/bin/file ${file}/bin/file
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    cmark-gfm
    flex
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  mesonFlags = [ 
    "-Dwith-bdb-path=${db53Combined}"
    "-Dwith-install-hooks=false"
  ];

  buildInputs = [
    acl
    avahi
    db53Combined
    dbus
    glib
    libevent
    libgcrypt
    localsearch
    openssl
    tinysparql
    pam
    talloc
    cups
    libkrb5
    perl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jcumming ];
  };
})
