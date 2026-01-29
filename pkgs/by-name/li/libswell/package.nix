{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gtk3,
  freetype,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "libswell";
  version = "unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "justinfrankel";
    repo = "WDL";
    rev = "c2db86d782b20a6008a88906ae964e71ed2cb099";
    hash = "sha256-Z7I194DGP2ml4loTKOIXolWzopxpN9tzVUbLgJBzaDQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/justinfrankel/WDL/commit/08677fc16e8f1c165070d65033fba50fc0ac7f71.patch";
      hash = "sha256-/tHMHi8Zs2GHTHjn75fdzUQTOb7aQ51zumsBERXTUGk=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    freetype
  ];

  preBuild = ''
    cd WDL/swell
  '';

  installPhase = ''
    mkdir -p "$out"/lib
    cp libSwell.${if stdenv.isDarwin then "dylib" else "so"} "$out"/lib
  '';

  meta = with lib; {
    description = "Simple Windows Emulation Layer";
    homepage = "https://www.cockos.com/wdl/";
    license = licenses.unfree; # possibly? see homepage
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [
      viraptor
    ];
  };
}
