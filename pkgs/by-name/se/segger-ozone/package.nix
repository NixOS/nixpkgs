{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  fontconfig,
  freetype,
  libICE,
  libSM,
  libX11,
  libXcursor,
  libXfixes,
  libXrandr,
  libXrender,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "segger-ozone";
  version = "3.40e";

  src = fetchurl {
    url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${
      lib.replaceString "." "" finalAttrs.version
    }_x86_64.tgz";
    hash = "sha256-UX7ZGWVtVphBMcQ0R0iiNYaDfSjYXjSpK9YMBHw2Pss=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    fontconfig
    freetype
    libICE
    libSM
    libX11
    libXcursor
    libXfixes
    libXrandr
    libXrender
    (lib.getLib stdenv.cc.cc)
  ];

  desktopItems = [
    (makeDesktopItem {
      categories = [
        "Development"
        "Debugger"
        "X-MandrivaLinux-MoreApplications-Development"
      ];
      comment = "SEGGER Ozone";
      desktopName = "Ozone";
      exec = "Ozone %%f";
      icon = "Ozone";
      keywords = [
        "ARM"
        "Development"
        "Embedded"
      ];
      name = "segger-ozone";
      startupNotify = true;
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp --recursive . $out/libexec/segger-ozone
    ln -s $out/libexec/segger-ozone/Ozone $out/bin/Ozone
    install -D --mode=0644 Ozone.png $out/share/icons/hicolor/256x256/apps/Ozone.png

    runHook postInstall
  '';

  meta = {
    description = "J-Link Debugger and Performance Analyzer";
    longDescription = ''
      Ozone is a cross-platform debugger and performance analyzer for J-Link
      and J-Trace.

        - Stand-alone graphical debugger
        - Debug output of any tool chain and IDE 1
        - C/C++ source level debugging and assembly instruction debugging
        - Debug information windows for any purpose: disassembly, memory,
          globals and locals, (live) watches, CPU and peripheral registers
        - Source editor to fix bugs immediately
        - High-speed programming of the application into the target
        - Direct use of J-Link built-in features (Unlimited Flash
          Breakpoints, Flash Download, Real Time Terminal, Instruction Trace)
        - Scriptable project files to set up everything automatically
          - New project wizard to ease the basic configuration of new projects

      1 Ozone has been tested with the output of the following compilers:
      GCC, Clang, ARM, IAR. Output of other compilers may be supported but is
      not guaranteed to be.
    '';
    homepage = "https://www.segger.com/products/development-tools/ozone-j-link-debugger";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.bmilanov ];
    platforms = [ "x86_64-linux" ];
  };
})
