{ stdenv, fetchgit, cups, libssh, libXpm, nx-libs, openldap, openssh
, makeWrapper, qtbase, qtsvg, qtx11extras, qttools, phonon, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "x2goclient";
  version = "unstable-2018-11-30";

  src = fetchgit {
   url = "git://code.x2go.org/x2goclient.git";
   rev = "659655675f11ffd361ab9fb48fa77a01a1536fe8";
   sha256 = "05gfs11m259bchy3k0ihqpwg9wf8lp94rbca5dzla9fjzrb7pyy4";
  };

  buildInputs = [ cups libssh libXpm nx-libs openldap openssh
                  qtbase qtsvg qtx11extras qttools phonon pkgconfig ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
     substituteInPlace Makefile \
       --replace "SHELL=/bin/bash" "SHELL=$SHELL" \
       --replace "lrelease-qt4" "${qttools.dev}/bin/lrelease" \
       --replace "qmake-qt4" "${qtbase.dev}/bin/qmake" \
       --replace "-o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "ETCDIR=$(out)/etc" "build_client" "build_man" ];

  enableParallelBuilding = true;

  installTargets = [ "install_client" "install_man" ];
  postInstall = ''
    wrapProgram "$out/bin/x2goclient" --suffix PATH : "${nx-libs}/bin:${openssh}/libexec";
  '';

  meta = with stdenv.lib; {
    description = "Graphical NoMachine NX3 remote desktop client";
    homepage = http://x2go.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
