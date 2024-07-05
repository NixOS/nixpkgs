{
  stdenv,
  lib,
  callPackage,
}:
let
  pname = "pcsx2";
  version = "1.7.5779";
  meta = with lib; {
    description = "Playstation 2 emulator";
    longDescription = ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    hydraPlatforms = platforms.linux;
    homepage = "https://pcsx2.net";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [
      hrdinka
      govanify
      matteopacini
    ];
    mainProgram = "pcsx2-qt";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance =
      lib.optional stdenv.isDarwin sourceTypes.binaryNativeCode
      ++ lib.optional stdenv.isLinux sourceTypes.fromSource;
  };
in
if stdenv.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
