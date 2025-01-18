{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwebm";
  version = "1.0.0.31";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libwebm";
    tag = "libwebm-${finalAttrs.version}";
    hash = "sha256-+ayX33rcX/jkewsW8WrGalTe9X44qFBHOrIYTteOQzc=";
  };

  patches = [
    # libwebm does not generate cmake exports by default,
    # which are necessary to find and use it as build-dependency
    # in other packages
    ./0001-cmake-exports.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  outputs = [
    "dev"
    "out"
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "WebM file parser";
    homepage = "https://www.webmproject.org/code/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ niklaskorz ];
    platforms = platforms.all;
  };
})
