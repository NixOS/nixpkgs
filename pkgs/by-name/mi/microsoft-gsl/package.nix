{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "microsoft-gsl";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
    hash = "sha256-NrnYfCCeQ50oHYFbn9vh5Z4mfyxc0kAM3qnzQdq9gyM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ gtest ];

  # C++17 required by latest gtest
  env.NIX_CFLAGS_COMPILE = "-std=c++17";

  doCheck = true;

  meta = with lib; {
    description = "C++ Core Guideline support library";
    longDescription = ''
      The Guideline Support Library (GSL) contains functions and types that are suggested for
      use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
      This package contains Microsoft's implementation of GSL.
    '';
    homepage = "https://github.com/Microsoft/GSL";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      thoughtpolice
      yuriaisaka
    ];
  };
}
