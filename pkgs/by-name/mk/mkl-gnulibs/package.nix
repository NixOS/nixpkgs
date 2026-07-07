{
  gcc,
  mkl,
}:

# Force MKL to link GNU openmp libs, not intel ones. Intel conflicts with
# pytorch, libgbm, anything else compiled with gcc + openmp. We have not found
# a way to reliably force this with the intel-provided auto-detecting
# libmkl_rt.so. - therefore we use a loader script (templated from
# libmkl_rt.so.in)
# Also, we must delete the libtbb.so in mkl as it ends up being used in rtech,
# whilst we want the separate version that we compile against which does
# have headers.
mkl.overrideAttrs (o: {
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = o.nativeBuildInputs ++ [ gcc ];

  postFixup = (o.postFixup or "") + ''
    find $out/lib -name '*tbb*' -delete

    rm $out/lib/libmkl_intel_thread.so
    rm $out/lib/libmkl_intel_thread.so.2

    gcc -shared ${./mkl_rt_shim.c} -o $out/lib/libmkl_rt_shim.so -L$out/lib -fopenmp

    rm $out/lib/libmkl_rt.so.2
    export gomp_loc=${gcc.cc.lib}
    substituteAll ${./libmkl_rt.so.in} $out/lib/libmkl_rt.so.2

    # If we call overrideAttrs on mkl to add the templated pc files later, we lose the extra attributes
    # we are setting, so we do the pc file generation here.
    substituteAll ${./mkl.pc.in} $out/lib/pkgconfig/mkl.pc
    # Need slightly different name for numpy, which special cases "mkl"
    substituteAll ${./mkl.pc.in} $out/lib/pkgconfig/mkl_rt.pc
  '';
})
// {
  isILP64 = false;
  implementation = "mkl";
  blasProvider = mkl;
  blasImplementation = "mkl";
  provider = mkl;
}
