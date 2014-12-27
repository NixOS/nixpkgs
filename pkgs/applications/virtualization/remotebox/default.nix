{ stdenv, fetchurl, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "1.9";
  name = "remotebox-${version}";

  src = fetchurl {
    url = "${meta.homepage}/downloads/RemoteBox-${version}.tar.bz2";
    sha256 = "0vsfz2qmha9nz60fyksgqqyrw4lz9z2d5isnwqc6afn8z3i1qmkp";
  };

  buildInputs = [ perl perlPackages.Gtk2 perlPackages.SOAPLite ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a docs/ share/ $out

    substituteInPlace remotebox --replace "\$Bin/" "\$Bin/../"
    install -t $out/bin remotebox

    mkdir -p $out/share/applications
    cp -p packagers-readme/*.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "VirtualBox client with remote management";
    homepage = http://remotebox.knobgoblin.org.uk/;
    license = with licenses; gpl2Plus;
    longDescription = ''
      VirtualBox is traditionally considered to be a virtualization solution
      aimed at the desktop.  While it is certainly possible to install
      VirtualBox on a server, it offers few remote management features beyond
      using the vboxmanage command line.
      RemoteBox aims to fill this gap by providing a graphical VirtualBox
      client which is able to manage a VirtualBox server installation.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; all;
  };
}
