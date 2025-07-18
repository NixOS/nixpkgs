{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soplex";
  version = "714";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-j5dsCAjEaReVpHHCM8FUyDIhxZ4P2yk2h89k5omTh8o=";
  };

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://scipopt.org";
    description = "Sequential object-oriented simPlex";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "soplex";
    maintainers = with lib.maintainers; [ david-r-cox ];
    platforms = lib.platforms.unix;
  };
})
