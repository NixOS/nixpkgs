{
  lib,
  stdenv,
  fetchurl,
  imake,
  libX11,
  libSM,
  libXext,
  libICE,
}:

stdenv.mkDerivation rec {
  pname = "lwm";
  version = "1.2.4";

  src = fetchurl {
    url = "http://www.jfc.org.uk/files/lwm/${pname}-${version}.tar.gz";
    sha256 = "1bcdr173f0gl61fyl43p3gr145angci7lvjqb8rl00y9f9amvh3y";
  };

  nativeBuildInputs = [ imake ];

  buildInputs = [
    libX11
    libSM
    libXext
    libICE
  ];

  dontConfigure = true;

  preBuild = ''
    sed -i 's|^LOCAL_LIBRARIES.*|& $(ICELIB)|' Imakefile
    xmkmf
  '';

  installPhase = ''
    install -dm755 $out/bin $out/share/man/man1
    install -m755 lwm $out/bin/lwm
    install -m644 lwm.man $out/share/man/man1/lwm.1
  '';

  meta = with lib; {
    description = "Lightweight Window Manager";
    longDescription = ''
      lwm is a window manager for X that tries to keep out of your face. There
      are no icons, no button bars, no icon docks, no root menus, no nothing: if
      you want all that, then other programs can provide it. There's no
      configurability either: if you want that, you want a different window
      manager; one that helps your operating system in its evil conquest of your
      disc space and its annexation of your physical memory.
    '';
    homepage = "http://www.jfc.org.uk/software/lwm.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    mainProgram = "lwm";
  };
}
