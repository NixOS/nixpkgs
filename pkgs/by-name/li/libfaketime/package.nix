{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  perl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "libfaketime";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    rev = "v${version}";
    sha256 = "sha256-a0TjHYzwbkRQyvr9Sj/DqjgLBnE1Z8kjsTQxTfGqLjE=";
  };

  patches = [
    ./nix-store-date.patch
  ];

  postPatch = ''
    patchShebangs test src
    for a in test/functests/test_exclude_mono.sh src/faketime.c ; do
      substituteInPlace $a \
        --replace /bin/bash ${stdenv.shell}
    done
    substituteInPlace src/faketime.c --replace @DATE_CMD@ ${coreutils}/bin/date
  '';

  PREFIX = placeholder "out";
  LIBDIRNAME = "/lib";

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=cast-function-type"
      "-Wno-error=format-truncation"
    ]
    # https://github.com/wolfcw/libfaketime/blob/6714b98794a9e8a413bf90d2927abf5d888ada99/README#L101-L104
    ++ lib.optionals (stdenv.hostPlatform.isLoongArch64 || stdenv.hostPlatform.isRiscV64) [
      "-DFORCE_PTHREAD_NONVER"
    ]
  );

  nativeCheckInputs = [ perl ];

  doCheck = true;

  meta = with lib; {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "faketime";
  };
}
