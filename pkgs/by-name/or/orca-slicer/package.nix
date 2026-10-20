{
  stdenvNoCC,
  callPackage,
  withSystemd ? stdenvNoCC.hostPlatform.isLinux,
  withNvidiaGLWorkaround ? false,
}:
callPackage ./linux.nix { inherit withSystemd withNvidiaGLWorkaround; }
