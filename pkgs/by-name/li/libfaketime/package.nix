{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  perl,
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

  buildInputs = [ coreutils ];

  postPatch =
    let
      dateCmd = lib.getExe' coreutils "date";
    in
    ''
      substituteInPlace src/faketime.c \
        --replace-fail 'date_cmd = "date"' 'date_cmd = "${dateCmd}"' \
        --replace-fail 'date_cmd = "gdate"' 'date_cmd = "${dateCmd}"'
    '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIRNAME=/lib"
  ];

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

  preCheck = ''
    patchShebangs test
    substituteInPlace test/functests/test_exclude_mono.sh \
      --replace-fail '/bin/bash' '$0'
  '';

  meta = {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      bjornfor
      usertam
    ];
    mainProgram = "faketime";
  };
})
