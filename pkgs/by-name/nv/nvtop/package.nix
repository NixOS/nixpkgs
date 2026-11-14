{
  lib,
  stdenv,
  autoAddDriverRunpath,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  gtest,
  libdrm,
  ncurses,
  pkg-config,
  udev,
  versionCheckHook,
  amd ? stdenv.hostPlatform.isLinux,
  apple ? stdenv.hostPlatform.isDarwin,
  ascend ? false, # Requires libdcmi, which is not packaged yet
  enflame ? stdenv.hostPlatform.isLinux,
  intel ? stdenv.hostPlatform.isLinux,
  ixml ? stdenv.hostPlatform.isLinux,
  metax ? stdenv.hostPlatform.isLinux,
  msm ? stdenv.hostPlatform.isLinux,
  nvidia ? stdenv.hostPlatform.isLinux,
  panfrost ? stdenv.hostPlatform.isLinux,
  panthor ? stdenv.hostPlatform.isLinux,
  radeon ? stdenv.hostPlatform.isLinux,
  rockchip ? stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch,
  tenstorrent ? stdenv.hostPlatform.isLinux,
  tpu ? false, # Requires libtpuinfo, which is not packaged yet
  v3d ? stdenv.hostPlatform.isLinux,
}:

let
  needDrm = amd || radeon || intel || msm || panfrost || panthor;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nvtop";
  version = "3.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    tag = finalAttrs.version;
    hash = "sha256-1hWgFn2pkH1+YvvFOCGPKviZLwW6l6PqrP99ty1FRtU=";
  };

  patches = [
    # tests: fix testLib build on Darwin
    # https://github.com/Syllo/nvtop/pull/550
    (fetchpatch2 {
      url = "https://github.com/Syllo/nvtop/commit/ced04c2ad679b279753c9c83ef513c459ca84a7e.patch?full_index=1";
      hash = "sha256-amA91FvgaRFqVgfw2KV6JsVqpva5kntlGjtlTUlwJjw=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "USE_LIBUDEV_OVER_LIBSYSTEMD" true)
    (lib.cmakeBool "AMDGPU_SUPPORT" amd)
    (lib.cmakeBool "APPLE_SUPPORT" apple)
    (lib.cmakeBool "ASCEND_SUPPORT" ascend)
    (lib.cmakeBool "ENFLAME_SUPPORT" enflame)
    (lib.cmakeBool "INTEL_SUPPORT" intel)
    (lib.cmakeBool "IXML_SUPPORT" ixml) # dlopens libixml.so from /usr/local/corex/lib{,64} or the library path; not packaged
    (lib.cmakeBool "METAX_SUPPORT" metax) # dlopens libmxsml.so from /opt/{mxdriver,maca,mxn100}/lib only; not packaged
    (lib.cmakeBool "MSM_SUPPORT" msm)
    (lib.cmakeBool "NVIDIA_SUPPORT" nvidia)
    (lib.cmakeBool "PANFROST_SUPPORT" panfrost)
    (lib.cmakeBool "PANTHOR_SUPPORT" panthor)
    (lib.cmakeBool "RADEON_SUPPORT" radeon)
    (lib.cmakeBool "ROCKCHIP_SUPPORT" rockchip)
    (lib.cmakeBool "TENSTORRENT_SUPPORT" tenstorrent)
    (lib.cmakeBool "TPU_SUPPORT" tpu)
    (lib.cmakeBool "V3D_SUPPORT" v3d)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional nvidia autoAddDriverRunpath;

  buildInputs = [
    ncurses
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux udev
  ++ lib.optional needDrm libdrm;

  # libdrm is dlopen'ed at runtime
  postFixup = lib.optionalString needDrm ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libdrm ]} $out/bin/nvtop
  '';

  doCheck = true;
  checkInputs = [ gtest ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Task monitor for GPUs and accelerators, similar to htop";
    longDescription = ''
      Nvtop (Neat Videocard TOP) is an htop-like task monitor for GPUs and accelerators.
      It can handle multiple GPUs and shows their usage and processes in an htop-like interface.
      Supported GPU families include AMD, Apple, Intel, NVIDIA, Qualcomm Adreno, Arm Mali,
      Broadcom VideoCore, Rockchip, MetaX, Enflame, Tenstorrent and Iluvatar CoreX.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      gbtb
      anthonyroussel
      moni
    ];
    mainProgram = "nvtop";
  };
})
