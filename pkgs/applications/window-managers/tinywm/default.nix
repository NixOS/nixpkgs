{ lib, stdenv, fetchFromGitHub
, libX11 }:

stdenv.mkDerivation rec {
  pname = "tinywm";
  version = "2014-04-22";

  src = fetchFromGitHub {
    owner = "mackstann";
    repo = pname;
    rev = "9d05612f41fdb8bc359f1fd9cc930bf16315abb1";
    sha256 = "1s7r4f2d3lk1i8h089v2vyrr02hh0y9i3ihl9kqgk9s87hqw8q5b";
  };

  buildInputs = [ libX11 ];

  dontConfigure = true;

  buildPhase = ''
    $CC -Wall -pedantic -I${libX11}/include tinywm.c -L${libX11}/lib -lX11 -o tinywm
  '';

  installPhase = ''
    install -dm755 $out/bin $out/share/doc/${pname}-${version}
    install -m755 tinywm -t $out/bin/
    # The annotated source code is a piece of documentation
    install -m644 annotated.c README -t $out/share/doc/${pname}-${version}
  '';

  meta = with lib;{
    description = "A tiny window manger for X11";
    longDescription = ''

      TinyWM is a tiny window manager that I created as an exercise in
      minimalism. It is also maybe helpful in learning some of the very basics
      of creating a window manager. It is only around 50 lines of C. There is
      also a Python version using python-xlib.

      It lets you do four basic things:

      - Move windows interactively with Alt+Button1 drag (left mouse button)
      - Resize windows interactively with Alt+Button3 drag (right mouse button)
      - Raise windows with Alt+F1 (not high on usability I know, but I needed a
        keybinding in there somewhere)
      - Focus windows with the mouse pointer (X does this on its own)
    '';
    homepage = "http://incise.org/tinywm.html";
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = libX11.meta.platforms;
    license = licenses.publicDomain;
  };
}
