{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "remotebox-${version}";
  version = "2.1";

  src = fetchurl {
    url = "http://remotebox.knobgoblin.org.uk/downloads/RemoteBox-${version}.tar.bz2";
    sha256 = "0pyi433pwbpyh58p08q8acav7mk90gchgjghvl9f8wqafx7bp404";
  };

  buildInputs = with perlPackages; [ perl Glib Gtk2 Pango SOAPLite ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/bin

    substituteInPlace remotebox --replace "\$Bin/" "\$Bin/../"
    install -v -t $out/bin remotebox
    wrapProgram $out/bin/remotebox --prefix PERL5LIB : $PERL5LIB

    cp -av docs/ share/ $out

    mkdir -pv $out/share/applications
    cp -pv packagers-readme/*.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "VirtualBox client with remote management";
    homepage = http://remotebox.knobgoblin.org.uk/;
    license = licenses.gpl2Plus;
    longDescription = ''
      VirtualBox is traditionally considered to be a virtualization solution
      aimed at the desktop. While it is certainly possible to install
      VirtualBox on a server, it offers few remote management features beyond
      using the vboxmanage command line.
      RemoteBox aims to fill this gap by providing a graphical VirtualBox
      client which is able to manage a VirtualBox server installation.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.all;
  };
}
