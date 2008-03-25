args: with args;

stdenv.mkDerivation {
  name="jwm-2.0.1";
  src = fetchurl {
     url = http://24.254.249.181:8080/joewing.net/programs/jwm/releases/jwm-2.0.1.tar.bz2;
     sha256 = "1ix5y00cmg3cyazl0adzgv49140zxaf2dpngyg1dyy4ma6ysdmnw";
  };

  buildInputs = [libX11 libXext libXinerama libXpm libXft];


  postInstall = ''
    sed -i -e s/rxvt/xterm/g $out/etc/system.jwmrc
    sed -i -e "s/.*Swallow.*\|.*xload.*//" $out/etc/system.jwmrc'';


  meta = {
  description = "JWM is a window manager for X11 window system. It is written in C and uses only Xlib at a minimum.";
  };

}
