{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, apfel
, gsl
, lhapdf
, libarchive
, libyamlcpp
, python3
, sqlite
, swig
}:

stdenv.mkDerivation rec {
  pname = "nnpdf";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "NNPDF";
    repo = pname;
    rev = version;
    sha256 = "sha256-Alx4W0TkPzJBsnRXcKBrlEU6jWTnOjrji/IPk+dNCw0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/NNPDF/nnpdf/commit/7943b62a91d3a41fd4f6366b18881d50695f4b45.diff";
      hash = "sha256-UXhTO7vZgJiY8h3bgjg7SQC0gMUQsYQ/V/PgtCEQ7VU=";
    })
  ];

  postPatch = ''
    for file in CMakeLists.txt buildmaster/CMakeLists.txt; do
      substituteInPlace $file \
        --replace "-march=nocona -mtune=haswell" ""
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apfel
    gsl
    lhapdf
    libarchive
    libyamlcpp
    python3
    python3.pkgs.numpy
    sqlite
    swig
  ];

  cmakeFlags = [
    "-DCOMPILE_filter=ON"
    "-DCOMPILE_evolvefit=ON"
  ];

  meta = with lib; {
    description = "An open-source machine learning framework for global analyses of parton distributions";
    homepage = "https://docs.nnpdf.science/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.isDarwin && stdenv.isAarch64) || (stdenv.isLinux && stdenv.isAarch64);
  };
}
