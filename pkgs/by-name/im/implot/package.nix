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
  version = "1.0";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = "v${version}";
    hash = "sha256-dMZ7B8qkBKloEXgwN+RMX9lL/Owq+nnE5PNigaw1mN0=";
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
