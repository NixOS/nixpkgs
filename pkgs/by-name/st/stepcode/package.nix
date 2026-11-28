{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "stepcode";
  version = "0.8.2-unstable-2026-09-28";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepcode";
    repo = "stepcode";
    rev = "24783b448511b8f6bce2829286a3f00015430236";
    hash = "sha256-wzdm18qTRW3NLLBTwO+1Gji3U7DXjWXeOYIt3zHB5U4=";
  };

  patches = [
    # exp2cxx emits a null element type for nested aggregates (e.g. LIST OF LIST) when
    # the compiler evaluates the left side of an assignment first, as GCC does on aarch64.
    # This makes brlcad's step-g segfault on aarch64-linux.
    ./fix-aggregate-referent-eval-order.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Library for reading and writing STEP Part 21 exchange files";
    homepage = "https://github.com/stepcode/stepcode";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
}
