{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "rttr";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "${pname}org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yxad8sj40wi75hny8w6imrsx8wjasjmsipnlq559n4b6kl84ijp";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_UNIT_TESTS=OFF"
    "-DBUILD_PACKAGE=OFF"
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "C++ Reflection Library";
    homepage = "https://www.rttr.org";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
