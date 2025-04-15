{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fontconfig,
  freetype,
  libICE,
  libSM,
  libX11,
  libXcursor,
  libXfixes,
  libXrandr,
  libXrender,
}:

stdenv.mkDerivation rec {
  pname = "segger-ozone";
  version =
    {
      x86_64-linux = "3.38c";
      i686-linux = "3.36";
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${
          builtins.replaceStrings [ "." ] [ "" ] version
        }_x86_64.tgz";
        hash = "sha256-GYiFP3aK+dqpZuoJlTxJbTboYtWY9WACbxB11TctsQE=";
      };
      i686-linux = fetchurl {
        url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${
          builtins.replaceStrings [ "." ] [ "" ] version
        }_i386.tgz";
        hash = "sha256-u2HGOsv46BRlmqiusZD9iakLx5T530DqauNDY3YTiDY=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook ];

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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv Lib lib
    mv * $out
    ln -s $out/Ozone $out/bin

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
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
