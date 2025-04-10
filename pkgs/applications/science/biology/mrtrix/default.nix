{
  stdenv,
  lib,
  fetchFromGitHub,
  python,
  makeWrapper,
  eigen,
  fftw,
  libtiff,
  libpng,
  zlib,
  ants,
  bc,
  qt5,
  libGL,
  libGLU,
  libX11,
  libXext,
  less,
  withGui ? true,
  fetchFromGitLab,
  fetchpatch,
}:

let
  # reverts 'eigen: 3.4.0 -> 3.4.0-unstable-2022-05-19'
  # https://github.com/NixOS/nixpkgs/commit/d298f046edabc84b56bd788e11eaf7ed72f8171c
  eigen' = (
    eigen.overrideAttrs (old: rec {
      version = "3.4.0";
      src = fetchFromGitLab {
        owner = "libeigen";
        repo = "eigen";
        tag = version;
        hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
      };
      patches = (old.patches or [ ]) ++ [
        # Fixes e.g. onnxruntime on aarch64-darwin:
        # https://hydra.nixos.org/build/248915128/nixlog/1,
        # originally suggested in https://github.com/NixOS/nixpkgs/pull/258392.
        #
        # The patch is from
        # ["Fix vectorized reductions for Eigen::half"](https://gitlab.com/libeigen/eigen/-/merge_requests/699)
        # which is two years old,
        # but Eigen hasn't had a release in two years either:
        # https://gitlab.com/libeigen/eigen/-/issues/2699.
        (fetchpatch {
          url = "https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch";
          hash = "sha256-8qiNpuYehnoiGiqy0c3Mcb45pwrmc6W4rzCxoLDSvj0=";
        })
      ];
    })
  );
in

stdenv.mkDerivation rec {
  pname = "mrtrix";
  version = "3.0.4-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "MRtrix3";
    repo = "mrtrix3";
    rev = "7843bfc53a75f465901804ccf3fd6797d77531dd";
    hash = "sha256-C4Io3VkX10eWia4djrYvN12fWmwm0j1G60I8lmFH49w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    less
    python
  ] ++ lib.optional withGui qt5.wrapQtAppsHook;

  buildInputs =
    [
      ants
      eigen'
      python
      fftw
      libtiff
      libpng
      zlib
    ]
    ++ lib.optionals withGui [
      libGL
      libGLU
      libX11
      libXext
      qt5.qtbase
      qt5.qtsvg
    ];

  nativeInstallCheckInputs = [ bc ];

  postPatch = ''
    patchShebangs --build ./build ./configure ./run_tests
    patchShebangs --host ./bin/*

    # patching interpreters before fixup is needed for tests:
    patchShebangs testing/binaries/data/vectorstats/*py

    substituteInPlace ./run_tests  \
      --replace-fail 'git submodule update --init $datadir >> $LOGFILE 2>&1' ""

    # reduce build noise
    substituteInPlace ./configure \
      --replace-fail "[ '-Wall' ]" "[]"

    # fix error output (cuts off after a few lines otherwise)
    substituteInPlace ./build  \
      --replace-fail 'stderr=subprocess.PIPE' 'stderr=None'
  '';

  configurePhase = ''
    runHook preConfigure
    export EIGEN_CFLAGS="-isystem ${eigen'}/include/eigen3"
    unset LD  # similar to https://github.com/MRtrix3/mrtrix3/issues/1519
    ./configure ${lib.optionalString (!withGui) "-nogui"};
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./build
    (cd testing && ../build)
    runHook postBuild
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    ./run_tests units
    ./run_tests binaries

    # can also `./run_tests scripts`, but this fails due to lack of FSL package
    # (and there's no convenient way to disable individual tests)
    runHook postInstallCheck
  '';
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -ar lib $out/lib
    cp -ar bin $out/bin
    runHook postInstall
  '';

  preFixup =
    if withGui then
      ''
        qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ants ]})
      ''
    else
      ''
        for prog in $out/bin/*; do
          if [[ -x "$prog" ]]; then
            wrapProgram $prog --prefix PATH : ${lib.makeBinPath [ ants ]}
          fi
        done
      '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://github.com/MRtrix3/mrtrix3";
    description = "Suite of tools for diffusion imaging";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.mpl20;
  };
}
