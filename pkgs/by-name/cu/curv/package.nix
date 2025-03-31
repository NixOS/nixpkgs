{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  git,
  pkg-config,
  boost,
  eigen,
  glm,
  libGL,
  libpng,
  openexr,
  tbb,
  xorg,
  ilmbase,
  llvmPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "curv";
  version = "0.5-unstable-2025-01-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "doug-moen";
    repo = "curv";
    rev = "ef082c6612407dd8abce06015f9a16b1ebf661b8";
    hash = "sha256-BGL07ZBA+ao3fg3qp56sVTe+3tM2SOp8TGu/jF7SVlM=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs =
    [
      boost
      # https://codeberg.org/doug-moen/curv/issues/228
      # reverts 'eigen: 3.4.0 -> 3.4.0-unstable-2022-05-19'
      # https://github.com/nixos/nixpkgs/commit/d298f046edabc84b56bd788e11eaf7ed72f8171c
      (eigen.overrideAttrs (old: rec {
        version = "3.4.0";
        src = fetchFromGitLab {
          owner = "libeigen";
          repo = "eigen";
          rev = version;
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
      }))
      glm
      libGL
      libpng
      openexr
      tbb
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ilmbase
      llvmPackages.openmp
    ];

  # force char to be unsigned on aarch64
  # https://codeberg.org/doug-moen/curv/issues/227
  NIX_CFLAGS_COMPILE = [ "-fsigned-char" ];

  # GPU tests do not work in sandbox, instead we do this for sanity
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$(set -x; $out/bin/curv -x "2 + 2")" -eq "4"
    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "2D and 3D geometric modelling programming language for creating art with maths";
    homepage = "https://codeberg.org/doug-moen/curv";
    license = licenses.asl20;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "curv";
  };
}
