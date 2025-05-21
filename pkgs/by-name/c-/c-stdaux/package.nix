{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "c-stdaux";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-stdaux";
    tag = "v${version}";
    hash = "sha256-MsnuEyVCmOIr/q6I1qyPsNXp48jxIEcXoYLHbOAZtW0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Assertion failed: (false && "!__builtin_constant_p(c_align_to(16, non_constant_expr ? 8 : 16))"),
  # function test_basic_gnuc, file ../src/test-basic.c, line 548.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/c-util/c-stdaux";
    description = "Auxiliary macros and functions for the C standard library";
    changelog = "https://github.com/c-util/c-stdaux/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
