{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  perl,
  coreutils,
}:
let
  hashes = {
    "0.9.10" = "sha256-DYRuQmIhQu0CNEboBAtHOr/NnWxoXecuPMSR/UQ/VIQ=";
    "0.9.11" = "sha256-a0TjHYzwbkRQyvr9Sj/DqjgLBnE1Z8kjsTQxTfGqLjE=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libfaketime";
  # 0.9.10 break dict-db-wiktionary and quartus-prime-lite on linux,
  # and 0.9.11 break everything on darwin
  version = if stdenv.hostPlatform.isDarwin then "0.9.10" else "0.9.11";

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    tag = "v${finalAttrs.version}";
    hash = hashes.${finalAttrs.version};
  };

  patches = [
    ./nix-store-date.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      name = "0001-libfaketime.c-wrap-timespec_get-in-TIME_UTC-macro.patch";
      url = "https://github.com/wolfcw/libfaketime/commit/e0e6b79568d36a8fd2b3c41f7214769221182128.patch";
      sha256 = "sha256-KwwP76v0DXNW73p/YBvwUOPdKMAcVdbQSKexD/uFOYo=";
    })
    (fetchpatch {
      name = "LFS64.patch";
      url = "https://github.com/wolfcw/libfaketime/commit/f32986867addc9d22b0fab29c1c927f079d44ac1.patch";
      hash = "sha256-fIXuxxcV9J2IcgwcwSrMo4maObkH9WYv1DC/wdtbq/g=";
    })
    # https://github.com/wolfcw/libfaketime/issues/277
    ./0001-Remove-unsupported-clang-flags.patch
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
