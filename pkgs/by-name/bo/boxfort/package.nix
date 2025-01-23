{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "boxfort";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "BoxFort";
    rev = "v${version}";
    sha256 = "jmtWTOkOlqVZ7tFya3IrQjr714Y8TzAVY5Cq+RzDuRs=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  preConfigure = ''
    patchShebangs ci/isdir.py
  '';

  nativeCheckInputs = with python3Packages; [ cram ];

  doCheck = true;

  outputs = [
    "dev"
    "out"
  ];

  meta = with lib; {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = licenses.mit;
    maintainers = with maintainers; [
      thesola10
      Yumasi
    ];
    platforms = platforms.unix;
  };
}
