{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  numactl,
  ncurses,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numatop";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "numatop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-951Sm2zu1mPxMbPdZy+kMH8RAQo0z+Gqf2lxsY/+Lrg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    numactl
    ncurses
  ];

  nativeCheckInputs = [ check ];

  doCheck = true;

  meta = {
    description = "Tool for runtime memory locality characterization and analysis of processes and threads on a NUMA system";
    mainProgram = "numatop";
    homepage = "https://01.org/numatop";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dtzWill ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
    ];
  };
})
