{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soplex";
  version = "716";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-v2lDtnY3O1nP8RYALqpeO8q4b3bUAKZe4b3QhtnGiGg=";
  };

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://scipopt.org";
    description = "Sequential object-oriented simPlex";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "soplex";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
