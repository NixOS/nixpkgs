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
  version = "1.1";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = "v${version}";
    hash = "sha256-PEqwmnPeDHt0LzO58jqwoYYgJmRIxpA4cZpo3YY3Zhw=";
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
