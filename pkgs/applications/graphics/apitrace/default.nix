{ lib, stdenv, fetchFromGitHub, cmake, libX11, procps, python2, libdwarf, qtbase, qtwebkit, wrapQtAppsHook, libglvnd }:

stdenv.mkDerivation rec {
  pname = "apitrace";
  version = "7.1-572-g${builtins.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    sha256 = "11bwb0l8cr1bf9bj1s6cbmi77d5fy4qrphj9cgmcd8jpa862anp5";
    rev = "26966134f15d28f6b4a9a0a560017b3ba36d60bf";
    repo = "apitrace";
    owner = "apitrace";
  };

  patches = [
    # glibc 2.34 compat
    # derived from https://github.com/apitrace/apitrace/commit/d28a980802ad48568c87da02d630c8babfe163bb
    ./glibc-2.34-compat.patch
  ];

  # LD_PRELOAD wrappers need to be statically linked to work against all kinds
  # of games -- so it's fine to use e.g. bundled snappy.
  buildInputs = [ libX11 procps python2 libdwarf qtbase qtwebkit ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  # Don't automatically wrap all binaries, I prefer to explicitly only wrap
  # `qapitrace`.
  dontWrapQtApps = true;

  postFixup = ''

    # Since https://github.com/NixOS/nixpkgs/pull/60985, we add `/run-opengl-driver[-32]`
    # to the `RUNPATH` of dispatcher libraries `dlopen()` ing OpenGL drivers.
    # `RUNPATH` doesn't propagate throughout the whole application, but only
    # from the module performing the `dlopen()`.
    #
    # Apitrace wraps programs by running them with `LD_PRELOAD` pointing to `.so`
    # files in $out/lib/apitrace/wrappers.
    #
    # Theses wrappers effectively wrap the `dlopen()` calls from `libglvnd`
    # and other dispatcher libraries, and run `dlopen()`  by themselves.
    #
    # As `RUNPATH` doesn't propagate through the whole library, and they're now the
    # library doing the real `dlopen()`, they also need to have
    # `/run-opengl-driver[-32]` added to their `RUNPATH`.
    #
    # To stay simple, we add paths for 32 and 64 bits unconditionally.
    # This doesn't have an impact on closure size, and if the 32 bit drivers
    # are not available, that folder is ignored.
    for i in $out/lib/apitrace/wrappers/*.so
    do
      echo "Patching OpenGL driver path for $i"
      patchelf --set-rpath "/run/opengl-driver/lib:/run/opengl-driver-32/lib:$(patchelf --print-rpath $i)" $i
    done

    # Theses open the OpenGL driver at runtime, but it is not listed as NEEDED libraries. They need
    # a reference to libglvnd.
    for i in $out/bin/eglretrace $out/bin/glretrace
    do
      echo "Patching RPath for $i"
      patchelf --set-rpath "${lib.makeLibraryPath [libglvnd]}:$(patchelf --print-rpath $i)" $i
    done

    wrapQtApp $out/bin/qapitrace
  '';

  meta = with lib; {
    homepage = "https://apitrace.github.io";
    description = "Tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
