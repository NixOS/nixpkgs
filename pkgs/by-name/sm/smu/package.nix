{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smu";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "Gottox";
    repo = "smu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jO0tUMC2mVhVOA0U6Lm/9wPPnFt6T8rZO5h0+S2kp8o=";
  };

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Simple markup - markdown like syntax";
    mainProgram = "smu";
    homepage = "https://github.com/Gottox/smu";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
