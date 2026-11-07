{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "mpark-variant";
  version = "v1.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mpark";
    repo = "variant";
    tag = "v1.4.0";
    hash = "sha256-RAIJTLFtvQFFyTapIwCHWT3IlyXMe8cEWdjRfHFp6D8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    description = "C++17 `std::variant` for C++11/14/17";
    homepage = "https://github.com/mpark/variant";
    license = licenses.bsl11;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ arntanguy ];
  };
}
