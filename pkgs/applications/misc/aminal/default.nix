{ buildGoPackage
, Carbon
, Cocoa
, Kernel
, cf-private
, fetchFromGitHub
, lib
, mesa_glu
, stdenv
, xorg
}:

buildGoPackage rec {
  name = "aminal-${version}";
  version = "0.8.6";

  goPackagePath = "github.com/liamg/aminal";

  buildInputs =
    lib.optionals stdenv.isLinux [
      mesa_glu
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXxf86vm
    ] ++ lib.optionals stdenv.isDarwin [
      Carbon
      Cocoa
      Kernel
      cf-private  /* Needed for NSDefaultRunLoopMode */
    ];

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "aminal";
    rev = "v${version}";
    sha256 = "0qhjdckj2kr0vza6qssd9z8dfrsif1qxb1mal1d4wgdsy12lrmwl";
  };

  preBuild = ''
    buildFlagsArray=("-ldflags=-X ${goPackagePath}/version.Version=${version}")
  '';

  meta = with lib; {
    description = "Golang terminal emulator from scratch";
    longDescription = ''
      Aminal is a modern terminal emulator for Mac/Linux implemented in Golang
      and utilising OpenGL.

      The project is experimental at the moment, so you probably won't want to
      rely on Aminal as your main terminal for a while.

      Features:
      - Unicode support
      - OpenGL rendering
      - Customisation options
      - True colour support
      - Support for common ANSI escape sequences a la xterm
      - Scrollback buffer
      - Clipboard access
      - Clickable URLs
      - Multi platform support (Windows coming soon...)
      - Sixel support
      - Hints/overlays
      - Built-in patched fonts for powerline
      - Retina display support
    '';
    homepage = https://github.com/liamg/aminal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
