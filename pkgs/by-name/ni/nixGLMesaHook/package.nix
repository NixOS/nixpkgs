{
  lib,
  makeSetupHook,
  mesa,
  runCommand,
}:
let
  mesa-drivers = [ mesa ];
  glxindirect = runCommand "mesa_glxindirect" { } ''
    mkdir -p $out/lib
    ln -s ${mesa}/lib/libGLX_mesa.so.0 $out/lib/libGLX_indirect.so.0
  '';
in
makeSetupHook {
  name = "nixGLMesaHook";

  substitutions = {
    libgl_driver_path = "${lib.makeSearchPathOutput "lib" "lib/dri" mesa-drivers}";
    ld_library_path = "${lib.makeLibraryPath mesa-drivers}:${glxindirect}/lib";
    egl_vendor_dir = "${mesa}/share/glvnd/egl_vendor.d";
  };
} ./nixgl-mesa-hook.sh
