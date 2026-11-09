{
  callPackage,
  gcc,
  mkl,
  patchelf,
}:

# Force MKL to link GNU openmp libs, not intel ones. Intel conflicts with
# pytorch, libgbm, anything else compiled with gcc + openmp. We have not found
# a way to reliably force this with the intel-provided auto-detecting
# libmkl_rt.so. - therefore we replace it with libmkl_gf_lp64.so (which
# already exports the full BLAS/LAPACK ABI directly, as well as using the
# GNU Fortran conventions for complex scalars that consumers - like scipy -
# expect), patched via patchelf to explicitly depend on the GNU-threaded
# backend and our preload shim below.
# Also, we must delete the libtbb.so in mkl as it ends up being used in rtech,
# whilst we want the separate version that we compile against which does
# have headers.
mkl.overrideAttrs (
  finalAttrs: o: {
    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = o.nativeBuildInputs ++ [
      gcc
      patchelf
    ];

    postFixup = (o.postFixup or "") + ''
      find $out/lib -name '*tbb*' -delete

      rm $out/lib/libmkl_intel_thread.so
      rm $out/lib/libmkl_intel_thread.so.2
      rm $out/lib/pkgconfig/*iomp*.pc

      gcc -shared ${./mkl_rt_shim.c} -o $out/lib/libmkl_rt_shim.so -L$out/lib -fopenmp

      # libmkl_gf_lp64.so already exports the full BLAS/LAPACK ABI, and
      # (unlike the real libmkl_rt.so.2 we are replacing) leaves resolving
      # its internal mkl_blas_* etc. symbols up to whatever is linked in via
      # DT_NEEDED/RTLD_GLOBAL, rather than auto-detecting and dlopen-ing a
      # threading backend itself. So we base our libmkl_rt.so.2 replacement
      # on it, and explicitly wire up the GNU-threaded backend and our
      # preload shim (which also provides MKL_Set_*_Layer stubs, since
      # libmkl_gf_lp64.so does not). This keeps libmkl_rt.so.2 a real ELF
      # shared object (unlike a GNU ld linker script), so it still works
      # with tools that expect that, such as patchelf or dlopen.
      rm $out/lib/libmkl_rt.so.2
      cp $out/lib/libmkl_gf_lp64.so.2 $out/lib/libmkl_rt.so.2
      chmod +w $out/lib/libmkl_rt.so.2
      patchelf \
        --set-soname libmkl_rt.so.2 \
        --add-needed libmkl_core.so \
        --add-needed libmkl_gnu_thread.so \
        --add-needed libmkl_rt_shim.so \
        --add-rpath $out/lib \
        $out/lib/libmkl_rt.so.2
      chmod -w $out/lib/libmkl_rt.so.2

      # If we call overrideAttrs on mkl to add the templated pc files later, we lose the extra attributes
      # we are setting, so we do the pc file generation here.
      substituteAll ${./mkl.pc.in} $out/lib/pkgconfig/mkl.pc
      # Need slightly different name for numpy, which special cases "mkl"
      substituteAll ${./mkl.pc.in} $out/lib/pkgconfig/mkl_rt.pc
    '';

    # The postFixup above hardcodes .so extensions and relies on a Linux-only
    # OpenMP conflict (libgomp vs libiomp5), so this only makes sense on Linux,
    # unlike vanilla mkl which also supports Darwin.
    meta = (o.meta or { }) // {
      platforms = [ "x86_64-linux" ];
    };

    passthru = (o.passthru or { }) // {
      isILP64 = false;
      implementation = "mkl";
      blasProvider = finalAttrs.finalPackage;
      blasImplementation = "mkl";
      provider = finalAttrs.finalPackage;
      tests.gnu-openmp = callPackage ./test { mkl-gnulibs = finalAttrs.finalPackage; };
    };
  }
)
