{
  lib,
  stdenv,
  pkg-config,
  gfortran,
  openmpi,
  fortranSupport,
}:

stdenv.mkDerivation {
  name = "openmpi-oshmem-pkg-config";
  dontUnpack = true;
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ] ++ lib.optional fortranSupport gfortran;

  buildPhase = ''
    runHook preBuild
    # Do not add OpenMPI to buildInputs: its setup flags would mask incomplete .pc files.
    test -f ${lib.getDev openmpi}/share/openmpi/help-opal-wrapper.txt
    export PKG_CONFIG_LIBDIR=${lib.getDev openmpi}/lib/pkgconfig
    unset PKG_CONFIG_PATH
    cat > consumer.c <<'EOF'
    #include <shmem.h>
    int main(void) { shmem_init(); shmem_finalize(); return 0; }
    EOF
    $CC consumer.c $("$PKG_CONFIG" --cflags --libs oshmem-c) -o consumer-c
    $CXX -x c++ consumer.c $("$PKG_CONFIG" --cflags --libs oshmem-cxx) -o consumer-cxx
  ''
  + lib.optionalString fortranSupport ''
    "$PKG_CONFIG" --exists ompi-fort ompi-f77 ompi-f90
    cat > consumer.f90 <<'EOF'
    program consumer
      include 'shmem.fh'
      call start_pes(0)
      call shmem_barrier_all()
      call shmem_finalize()
    end program
    EOF
    $FC consumer.f90 $("$PKG_CONFIG" --cflags --libs oshmem-fort) -o consumer-fortran
  ''
  + lib.optionalString (!fortranSupport) ''
    for module in oshmem-fort ompi-fort ompi-f77 ompi-f90; do
      ! "$PKG_CONFIG" --exists "$module"
    done
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp consumer-c consumer-cxx ${lib.optionalString fortranSupport "consumer-fortran"} $out/bin/
  '';

  # Compile and link HOST binaries; executing them requires an MPI runtime.
  meta.platforms = lib.platforms.linux;
}
