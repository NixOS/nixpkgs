{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "pystring";
  version = "1.1.4-unstable-2025-10-07";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "pystring";
    rev = "a09708a4870db7862e1a1aa42658c8e6e36547e7";
    hash = "sha256-S43OkXcOCzPds2iDLunqg9a1zOiODo2dB9ReuOfe7Bw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/imageworks/pystring/";
    description = "Collection of C++ functions which match the interface and behavior of python's string class methods using std::string";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
