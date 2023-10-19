{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ninja
, opencv
, SDL2
, gtk3
, catch2_3
, spdlog
, exiv2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "xpano";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "krupkat";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f95spf7bbbdvbr4gqfyrs161049jj1wnkvf5wgsd0ga3vb15mcj";
    fetchSubmodules = true;
  };

  patches = [
    # force install desktop + icon files
    ./skip_prefix_check.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    opencv
    SDL2
    gtk3
    spdlog
    # exiv2 # TODO: enable when 0.28.0 is available
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  ];

  meta = with lib; {
    description = "A panorama stitching tool";
    homepage = "https://krupkat.github.io/xpano/";
    changelog = "https://github.com/krupkat/xpano/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ krupkat ];
    platforms = platforms.linux;
  };
}
