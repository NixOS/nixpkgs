{ stdenv
, overrideDerivation

# required for gcc plugins
, gmp, libmpc, mpfr

# the base kernel
, kernel

, grsecPatch
, kernelPatches ? []

, localver ? "-grsec"
, modDirVersion ? "${kernel.version}${localver}"
, extraConfig ? ""
, ...
} @ args:

assert (kernel.version == grsecPatch.kver);

overrideDerivation (kernel.override {
  inherit modDirVersion;
  kernelPatches = [ grsecPatch ] ++ kernelPatches ++ (kernel.kernelPatches or []);
  inherit extraConfig;
  ignoreConfigErrors = true;
}) (attrs: {
  nativeBuildInputs = [ gmp libmpc mpfr ] ++ (attrs.nativeBuildInputs or []);
  preConfigure = ''
    echo ${localver} >localversion-grsec
    ${attrs.preConfigure or ""}
  '';
})
