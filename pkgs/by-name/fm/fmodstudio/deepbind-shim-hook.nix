{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "deepbind-shim-hook";
  substitutions = {
    shimTemplate = ./deepbind-shim.c.in;
  };
  meta = {
    description = "Compile and inject a shim that adds RTLD_DEEPBIND to dlopen() calls for specified libraries using LD_PRELOAD";
    longDescription = ''
      Solves symbol interposition crashes when a proprietary shared library
      (e.g. libfsbvorbis) statically bundles a common library (e.g. libvorbis)
      but exports the same symbols. If another copy of that library is loaded
      in the same process (e.g. via qtwebengine -> ffmpeg -> libvorbis), the
      dynamic linker resolves the bundled library's internal calls to the
      system copy, causing ABI mismatches and segfaults.

      Usage:
        nativeBuildInputs = [ deepbindShimHook ];
        deepbindLibraries = [ "libfsbvorbis" ];

      The hook compiles a small C shim during preFixup and automatically
      injects it into the active wrapping mechanism (wrapQtAppsHook,
      wrapGAppsHook, or makeWrapper).

      RTLD_DEEPBIND has no ELF DT_FLAGS_1 equivalent. It can only be applied at
      dlopen() time, which is why a shim is necessary.
    '';
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ilkecan ];
  };
} ./deepbind-shim-hook.sh
