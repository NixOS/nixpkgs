{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoAddDriverRunpath,
  autoreconfHook,
  numactl,
  libuuid,
  rdma-core,
  libfabric,
  hwloc,
  cudaPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-ofi-nccl";
  version = "1.19.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-ofi-nccl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1gPIuZzS53cMRckiBkRRzMw3RzoAvu3v0xzt0rwyysk=";
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoreconfHook
  ];

  buildInputs = [
    numactl
    libuuid
    rdma-core
    libfabric
    hwloc
  ]
  ++ (with cudaPackages; [
    cuda_cudart
    nccl
  ]);

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This is a plugin which lets EC2 developers use libfabric as network provider while running NCCL applications";
    homepage = "https://github.com/aws/aws-ofi-nccl";
    changelog = "https://github.com/aws/aws-ofi-nccl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
    platforms = lib.platforms.all;
  };
})
