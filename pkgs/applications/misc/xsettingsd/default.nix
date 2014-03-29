{stdenv, fetchgit, pkgconfig, xlibs, scons}:

stdenv.mkDerivation rec {
  name = "xsettingsd";

  src = fetchgit {
    url = "git://github.com/derat/xsettingsd.git";
    sha256 = "1fpcdj0a8rm0wjj5xl63ksdj7390lcbcvmn7gw3vkcv12fs0m4a6";
  };
  
  patches = [ ./xsettingsd.patch ];
  
  buildInputs = [ scons xlibs.libX11 pkgconfig ];
  
  buildPhase = ''
  scons xsettingsd dump_xsettings
  '';
  
  installPhase = ''
  mkdir -p $out/bin
  mv xsettingsd $out/bin
  mv dump_xsettings $out/bin
  '';

  meta = {
    description = "A daemon that implements the XSETTINGS specification";
    longDescription = ''
    It can serve as an alternative to gnome-settings-daemon for users who are not using the GNOME desktop environment but who still run GTK+ applications and want to configure things such as themes, font antialiasing/hinting, and UI sound effects.
    '';
    homepage = http://code.google.com/p/xsettingsd/;
    license = "BSD";
    maintainers = stdenv.lib.maintainers.hinton;
    platforms = stdenv.lib.platforms.linux;
  };
}
