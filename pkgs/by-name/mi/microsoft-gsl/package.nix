{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microsoft-gsl";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rfSfgyjU1U6gaWzlx2CeaCSb784L29vHDAC/PQl+s6E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ gtest ];

  # C++17 required by latest gtest
  env.NIX_CFLAGS_COMPILE = "-std=c++17";

  doCheck = true;

  meta = {
    description = "C++ Core Guideline support library";
    longDescription = ''
      The Guideline Support Library (GSL) contains functions and types that are suggested for
      use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
      This package contains Microsoft's implementation of GSL.
    '';
    homepage = "https://github.com/Microsoft/GSL";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      thoughtpolice
      yuriaisaka
    ];
  };
})
