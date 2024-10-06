{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simpleini";
  version = "4.22";

  src = fetchFromGitHub {
    owner = "brofield";
    repo = "simpleini";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H4J4+v/3A8ZTOp4iMeiZ0OClu68oP4vUZ8YOFZbllcM=";
  };

  nativeBuildInputs = [
    cmake
    gtest
  ];

  cmakeFlags = [ "-DSIMPLEINI_USE_SYSTEM_GTEST=ON" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform C++ library providing a simple API to read and write INI-style configuration files";
    homepage = "https://github.com/brofield/simpleini";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.all;
  };
})
