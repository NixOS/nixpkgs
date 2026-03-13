{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  vcpkg,
  imgui,
}:

stdenv.mkDerivation rec {
  pname = "implot";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = "v${version}";
    hash = "sha256-/wkVsgz3wiUVZBCgRl2iDD6GWb+AoHN+u0aeqHHgem0=";
  };

  cmakeRules = "${vcpkg.src}/ports/implot";
  postPatch = ''
    cp "$cmakeRules"/CMakeLists.txt ./
  '';

  buildInputs = [ imgui ];
  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    implot-demos = callPackage ./demos { };
  };

  meta = {
    description = "Immediate Mode Plotting";
    homepage = "https://github.com/epezent/implot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    platforms = lib.platforms.all;
  };
}
