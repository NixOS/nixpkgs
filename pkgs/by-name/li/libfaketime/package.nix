{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfaketime";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hd59b7pc6GIDvRR6EEosr/f8sKuV2q7RU7gDSaGFp3Y=";
  };

  patches = [
    ./nix-store-date.patch
  ];

  postPatch = ''
    patchShebangs test src
    substituteInPlace test/functests/test_exclude_mono.sh src/faketime.c \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace src/faketime.c \
      --replace-fail @DATE_CMD@ ${lib.getExe' coreutils "date"}
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

  meta = {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "faketime";
  };
})
