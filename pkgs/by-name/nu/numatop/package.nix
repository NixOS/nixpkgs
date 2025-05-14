{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  numactl,
  ncurses,
  check,
}:

stdenv.mkDerivation rec {
  pname = "numatop";
  version = "2.2";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "numatop";
    rev = "v${version}";
    sha256 = "sha256-GJvTwqgx34ZW10eIJj/xiKe3ZkAfs7GlJImz8jrnjfI=";
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

  patches = [
    (fetchpatch {
      # https://github.com/intel/numatop/pull/54
      url = "https://github.com/intel/numatop/compare/eab0ac5253c5843aa0f0ac36e2eec7612207711b...c1001fd926c24eae2d40729492e07270ce133b72.patch";
      sha256 = "sha256-TbMLv7TT9T8wE4uJ1a/AroyPPwrwL0eX5IBLsh9GTTM=";
      name = "fix-string-operations.patch";
    })
    (fetchpatch {
      # https://github.com/intel/numatop/pull/64
      url = "https://github.com/intel/numatop/commit/635e2ce2ccb1ac793cc276a7fcb8a92b1ffefa5d.patch";
      sha256 = "sha256-IevbSFJRTS5iQ5apHOVXzF67f3LJaW6j7DySFmVuyiM=";
      name = "fix-format-strings-mvwprintw.patch";
    })
  ];

  doCheck = true;

  meta = with lib; {
    description = "Tool for runtime memory locality characterization and analysis of processes and threads on a NUMA system";
    mainProgram = "numatop";
    homepage = "https://01.org/numatop";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
    ];
  };
}
