{
  pkgs,
  lib,
  cmake,
  ninja,
  sphinx,
  python3Packages,
}:

pkgs.stdenv.mkDerivation {
  pname = "ckdl";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "tjol";
    repo = "ckdl";
    tag = "1.0";
    hash = "sha256-qEfRZzoUQZ8umdWgx+N4msjPBbuwDtkN1kNDfZicRjY=";
  };

  outputs = [
    "bin"
    "dev"
    "lib"
    "doc"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    sphinx
    python3Packages.furo
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  postPatch = ''
    cd doc
    make singlehtml
    mkdir -p $doc/share/doc
    mv _build/singlehtml $doc/share/doc/ckdl

    cd ..
  '';

  postInstall = ''
    mkdir -p $bin/bin

    # some tools that are important for debugging.
    # idk why they are not copied to bin by cmake, but I’m too tired to figure it out
    install src/utils/ckdl-tokenize $bin/bin
    install src/utils/ckdl-parse-events $bin/bin
    install src/utils/ckdl-cat $bin/bin
    touch $out
  '';

  meta = {
    description = "C library that implements reading and writing the KDL Document Language";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
