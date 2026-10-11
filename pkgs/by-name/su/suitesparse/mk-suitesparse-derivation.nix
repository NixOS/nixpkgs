{
  lib,
  stdenv,
  suitesparseSource,
  cmake,
  fixDarwinDylibNames,
  testers,
  enableCuda,
  addDriverRunpath,
  cudaPackages,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "moduleName"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      pname,
      moduleName,
      cmakeDir ? "../${moduleName}",
      src ? suitesparseSource,
      outputs ? [
        "out"
        "dev"
      ],
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      cmakeFlags ? [ ],
      passthru ? { },
      meta ? { },
      ...
    }@attrs:
    {
      pname = "suitesparse-${pname}";
      inherit src outputs cmakeDir;

      nativeBuildInputs = [
        cmake
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        fixDarwinDylibNames
      ]
      ++ lib.optionals enableCuda [
        addDriverRunpath
        cudaPackages.cuda_nvcc
      ]
      ++ nativeBuildInputs;

      buildInputs =
        lib.optionals enableCuda [
          cudaPackages.cuda_cudart
          cudaPackages.cuda_nvrtc
          cudaPackages.libcublas
        ]
        ++ buildInputs;

      cmakeFlags = [
        (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
        (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
        (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
        (lib.cmakeBool "SUITESPARSE_DEMOS" false)
        (lib.cmakeBool "SUITESPARSE_USE_STRICT" true)
        (lib.cmakeBool "SUITESPARSE_USE_FORTRAN" false)
        (lib.cmakeBool "SUITESPARSE_USE_CUDA" enableCuda)
      ]
      ++ lib.optionals enableCuda [
        (lib.cmakeFeature "SUITESPARSE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
      ]
      ++ cmakeFlags;

      # Follow Spack's practice of enabling backwards compatiblity by creating symlinks to headers
      # found in the nested include/suitesparse directory at the root of include:
      # https://github.com/spack/spack-packages/blob/9a7f32a93e4096ca0747ac19a10f77f9d2762786/repos/spack_repo/builtin/packages/suite_sparse/package.py#L324-L332
      postInstall = ''
        nixLog "creating symlinks in ''${!outputDev:?}/include for backwards compat"
        pushd "''${!outputDev:?}/include" >/dev/null
        ln -svrf suitesparse/* .
        popd >/dev/null
      '';

      passthru = {
        tests = {
          cmake-config = testers.hasCmakeConfigModules {
            inherit (finalAttrs) version;
            package = finalAttrs.finalPackage;
            moduleNames = [ moduleName ];
            versionCheck = true;
          };
          pkg-config = testers.hasPkgConfigModules {
            inherit (finalAttrs) version;
            moduleNames = [ moduleName ];
            package = finalAttrs.finalPackage;
            versionCheck = true;
          };
        };
      }
      // passthru;

      meta = {
        homepage = "https://github.com/DrTimothyAldenDavis/SuiteSparse/tree/dev/${moduleName}";
        platforms = with lib.platforms; unix;
      }
      // meta;
    };
}
