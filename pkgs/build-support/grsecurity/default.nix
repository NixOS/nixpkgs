{ stdenv

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

(kernel.override {
  inherit modDirVersion;
  # TODO: unique is a work-around
  kernelPatches = stdenv.lib.unique ([ grsecPatch ] ++ kernelPatches ++ (kernel.kernelPatches or []));
  extraConfig = ''
    GRKERNSEC y
    PAX y
    ${extraConfig}
  '';

  # Enabling grsecurity/PaX deselects several other options implicitly,
  # causing the configfile checker to fail (when it finds that options
  # expected to be enabled are not).
  ignoreConfigErrors = true;
}).overrideAttrs (attrs: {
  nativeBuildInputs = (stdenv.lib.chooseDevOutputs [ gmp libmpc mpfr ]) ++ (attrs.nativeBuildInputs or []);
  preConfigure = ''
    echo ${localver} >localversion-grsec
    ${attrs.preConfigure or ""}
  '';
})
