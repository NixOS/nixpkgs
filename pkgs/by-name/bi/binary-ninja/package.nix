{ stdenv
, lib
, fetchurl
, unzip
, autoPatchelfHook
, dbus
, fontconfig
, freetype
, fvwm3
, glxinfo
, libGLU
, libxkbcommon
, wayland
, x11basic
, xcbproto
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
, xcbutilxrm
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "binary-ninja";
  version = "4.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20240625203027/https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
    hash = "sha256-Q9CR3UVPzFzCHFrMxIdGrQ0RqL0L566MBZnGG/3nOB4=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    fvwm3
    glxinfo
    libGLU
    libxkbcommon
    stdenv.cc.cc.lib
    wayland
    x11basic
    xcbproto
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    xcbutilxrm
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/

    mkdir $out/bin
    ln -s $out/binaryninja $out/bin/binaryninja

    runHook postInstall
  '';

  meta = with lib; {
    description = "Interactive decompiler, disassembler, debugger";
    homepage = "https://binary.ninja/";
    license = {
      fullName = "Binaryninja Non-Commercial License Agreement";
      url = "https://docs.binary.ninja/about/license.html";
      free = false;
    };
    mainProgram = "binaryninja";
    maintainers = with maintainers; [ rookeur ];
    platforms = [ "x86_64-linux" ];
  };
})
