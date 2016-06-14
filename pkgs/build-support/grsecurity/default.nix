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
  kernelPatches = [ { inherit (grsecPatch) name patch; } ] ++ kernelPatches ++ (kernel.kernelPatches or []);
  features = (kernel.features or {}) // { grsecurity = true; };
  inherit extraConfig;
  ignoreConfigErrors = true;
}) (attrs: {
  nativeBuildInputs = [ gmp libmpc mpfr ] ++ (attrs.nativeBuildInputs or []);
  preConfigure = ''
    echo ${localver} >localversion-grsec
    ${attrs.preConfigure or ""}
  '';
})
