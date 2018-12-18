{ fetchFromGitHub, stdenv, lib, gettext, gtk2, makeWrapper, perlPackages, gnome2 }:

let
  perlDeps = with perlPackages; [
    Glib Gtk2 Gnome2 Pango Cairo Gnome2Canvas Gnome2VFS Gtk2GladeXML Gtk2TrayIcon
    XMLLibXML XMLSAXBase XMLParser XMLRSS
    HTMLParser
    DateTime DateTimeFormatMail DateTimeFormatW3CDTF DateTimeLocale DateTimeTimeZone
    ParamsValidate
    ModuleImplementation ModuleRuntime
    TryTiny
    ClassSingleton
    URI
    AnyEvent AnyEventHTTP
    commonsense
    FileSlurp
    JSON
    Guard
    LocaleGettext
  ];
  libs = [
    stdenv.cc.cc.lib
    gtk2
  ];
in
stdenv.mkDerivation rec {
  version = "git-2017-12-01";
  name = "yarssr-${version}";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "yarssr";
    rev = "e70eb9fc6563599bfb91c6de6a79654de531c18d";
    sha256 = "0x7hz8x8qyp3i1vb22zhcnvwxm3jhmmmlr22jqc5b09vpmbw1l45";
  };

  nativeBuildInputs = [ perlPackages.perl gettext makeWrapper ];
  buildInputs = perlDeps ++ [gnome2.libglade];
  propagatedBuildInputs = libs ++ perlDeps;

  installPhase = ''
    DESTDIR=$out make install
    mv $out/usr/* $out/
    rm -R $out/usr
    sed -i -r "s!use lib [^;]+;!use lib '$out/share/yarssr';!" $out/bin/yarssr
    sed -i -r "s!$Yarssr::PREFIX = [^;]+;!$Yarssr::PREFIX = '$out';!" $out/bin/yarssr
    sed -i -r "s!use Yarssr::Browser;!!" $out/share/yarssr/Yarssr/GUI.pm
    chmod a+x $out/bin/yarssr
  '';

  postFixup = ''
    wrapProgram $out/bin/yarssr \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath libs} \
      --set PERL5LIB "${perlPackages.makePerlPath perlDeps}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tsyrogit/zxcvbn-c;
    description = "A fork of Yarssr (a RSS reader for the GNOME Tray) from http://yarssr.sf.net with various fixes.";
    license = licenses.gpl1;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xurei ];
  };
}
