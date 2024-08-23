{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soplex";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-f4PMJz/VHCx5Uk7M9JdE+4Qpf29X3S/umoiAo8NXYrU=";
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
