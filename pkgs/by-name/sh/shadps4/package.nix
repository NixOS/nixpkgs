{
  lib,
  callPackage,
}:

callPackage ./emulator.nix { } // {
  meta = {
    description = "Early in development PS4 emulator";
    homepage = "https://github.com/shadps4-emu/shadPS4";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ryand56
      liberodark
    ];
    mainProgram = "shadps4";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
}
