{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soplex";
  version = "712";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-8muN9wYDQX5CULifKBYO/t9whS2LsatrYB2khlV0akg=";
  };

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://scipopt.org";
    description = "Sequential object-oriented simPlex";
    license = with licenses; [ asl20 ];
    mainProgram = "soplex";
    maintainers = with maintainers; [ david-r-cox ];
    platforms = platforms.unix;
  };
})
