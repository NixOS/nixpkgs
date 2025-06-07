{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfaketime";
  version = "0.9.12-rc1"; # not upstream yet, WIP

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    rev = "0277016bb5a33b412bd13af9905908524b709c7f"; # not upstream yet, WIP
    hash = "sha256-JiXirneGMaPGfw3G88hfJZ6cyjlPOQYtiwNcyMLnAuw="; # not upstream yet, WIP
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
