{
  lib,
  mkCapsule,
  libglvnd,
}:

mkCapsule {
  pname = "libglcapsule";
  dependencies = [ libglvnd ];
  objects = [ "libGL.so" "libEGL.so" "libGLESv1_CM.so" "libGLESv2.so" "libGLX.so" "libOpenGL.so" ];
  meta = {
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
