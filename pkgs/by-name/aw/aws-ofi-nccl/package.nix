{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoAddDriverRunpath,
  autoreconfHook,
  libfabric,
  hwloc,
  cudaPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-ofi-nccl";
  version = "1.22.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-ofi-nccl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jnT8V4KHixUJ8EKwQydC3suVejLJ1GbRx6iLSBPLfR8=";
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoreconfHook
  ];

  buildInputs = [
    libfabric
    hwloc
    cudaPackages.cuda_cudart
  ];

  postPatch = ''
    patchShebangs m4
    echo "$version" > .release_version
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--enable-platform-aws"
    "--with-cuda=${cudaPackages.cuda_nvcc}"
    "--with-libfabric=${libfabric}"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "This is a plugin which lets EC2 developers use libfabric as network provider while running NCCL applications";
    homepage = "https://github.com/aws/aws-ofi-nccl";
    changelog = "https://github.com/aws/aws-ofi-nccl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _81reap
      jlesquembre
    ];
    platforms = lib.platforms.linux;
  };
})
