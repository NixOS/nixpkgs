{
  lib,
  runCommand,
  R,
  arf,
  makeBinaryWrapper,
  rPackages,
  recommendedPackages ? (
    with rPackages;
    [
      boot
      class
      cluster
      codetools
      foreign
      KernSmooth
      lattice
      MASS
      Matrix
      mgcv
      nlme
      nnet
      rpart
      spatial
      survival
    ]
  ),
  packages ? [ ],
}:

runCommand (arf.name + "-wrapper")
  {
    strictDeps = true;
    __structuredAttrs = true;

    preferLocalBuild = true;
    allowSubstitutes = false;

    buildInputs = [
      arf
    ]
    ++ recommendedPackages
    ++ packages;

    nativeBuildInputs = [
      makeBinaryWrapper
      R
    ];

    passthru = { inherit recommendedPackages; };

    meta = arf.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [ ];
      # prefer wrapper over the package
      priority = (arf.meta.priority or lib.meta.defaultPriority) - 1;
    };
  }
  ''
    makeWrapper "${lib.getExe arf}" "$out/bin/arf" \
      --prefix "PATH" ":" "${R}/bin" \
      --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
  ''
