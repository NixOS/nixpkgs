{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcircle";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "libcircle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EfnoNL6wo6qQES6XzMtpTpYcsJ8V2gy32i26wiTldH0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [ mpi ];

  meta = {
    description = "API for distributing embarrassingly parallel workloads using self-stabilization";
    homepage = "http://hpc.github.io/libcircle/";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
