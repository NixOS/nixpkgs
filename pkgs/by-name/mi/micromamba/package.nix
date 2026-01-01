{
  lib,
  stdenv,
<<<<<<< HEAD
  mamba-cpp,
  testers,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micromamba";
  version = mamba-cpp.version;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin

    # We copy the binary instead of symlinking.
    # Mamba determines its identity (mamba vs micromamba) by reading /proc/self/exe.
    # If we symlink, it resolves to 'mamba', causing shell init scripts to fail.
    # Ref: <https://github.com/NixOS/nixpkgs/pull/460788#issuecomment-3585230714>
    cp ${mamba-cpp}/bin/mamba $out/bin/micromamba
  '';

  passthru.tests = {
    # 1. Standard version check
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "micromamba --version";
    };

    # 2. Regression test for the shell initialization issue
    # This ensures that after sourcing the shell hook, `micromamba activate` works.
    # If the binary were a symlink resolving to 'mamba', the hook would define a
    # `mamba()` function instead of `micromamba()`, causing `micromamba activate` to fail.
    shell-init =
      runCommand "test-micromamba-shell-hook"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          # The shell hook includes 'complete' commands for bash completion,
          # which fail in non-interactive bash. We temporarily ignore errors
          # during eval since we only care about the function definition.
          set +e
          eval "$(micromamba shell hook --shell bash)" 2>/dev/null
          set -e

          # Test that the micromamba function works (not mamba).
          # If shell initialization fails above, then we expect to see an
          # error beginning with something like:
          #     'mamba' is running as a subprocess and can't modify the parent shell.
          micromamba activate

          touch $out
        '';
  };

  meta = mamba-cpp.meta // {
    maintainers = with lib.maintainers; [ mausch ];
    mainProgram = "micromamba";
  };
})
=======
  fetchFromGitHub,
  fetchpatch,
  bzip2,
  cli11,
  cmake,
  curl,
  ghc_filesystem,
  libarchive,
  libsolv,
  yaml-cpp,
  nlohmann_json,
  python3,
  reproc,
  spdlog,
  tl-expected,
}:

let
  libsolv' = libsolv.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DENABLE_CONDA=true"
    ];

    patches = [
      # Apply the same patch as in the "official" boa-forge build:
      # https://github.com/mamba-org/boa-forge/tree/master/libsolv
      (fetchpatch {
        url = "https://raw.githubusercontent.com/mamba-org/boa-forge/20530f80e2e15012078d058803b6e2c75ed54224/libsolv/conda_variant_priorization.patch";
        sha256 = "1iic0yx7h8s662hi2jqx68w5kpyrab4fr017vxd4wyxb6wyk35dd";
      })
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "micromamba";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = "micromamba-" + version;
    hash = "sha256-sxZDlMFoMLq2EAzwBVO++xvU1C30JoIoZXEX/sqkXS0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bzip2
    cli11
    nlohmann_json
    curl
    libarchive
    yaml-cpp
    libsolv'
    reproc
    spdlog
    ghc_filesystem
    python3
    tl-expected
  ];

  cmakeFlags = [
    "-DBUILD_LIBMAMBA=ON"
    "-DBUILD_SHARED=ON"
    "-DBUILD_MICROMAMBA=ON"
    # "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];

  meta = with lib; {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ mausch ];
    mainProgram = "micromamba";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
