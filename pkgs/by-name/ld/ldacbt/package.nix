{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ldacBT";
  version = "2.0.2.3";

  src = fetchFromGitHub {
    repo = "ldacBT";
    owner = "ehfive";
    tag = "v${version}";
    sha256 = "09dalysx4fgrgpfdm9a51x6slnf4iik1sqba4xjgabpvq91bnb63";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # CMakeLists.txt by default points to $out
    "-DINSTALL_INCLUDEDIR=${placeholder "dev"}/include"
  ];

  # Fix the build with CMake 4.
  #
  # See: <https://github.com/EHfive/ldacBT/pull/1>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.0...3.10)'
  '';

  meta = with lib; {
    description = "AOSP libldac dispatcher";
    homepage = "https://github.com/EHfive/ldacBT";
    license = licenses.asl20;
    # libldac code detects & #error's out on non-LE byte order
    platforms = platforms.littleEndian;
    maintainers = [ ];
  };
}
