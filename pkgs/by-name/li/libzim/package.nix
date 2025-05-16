{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  icu,
  meson,
  ninja,
  pkg-config,
  python3,
  xapian,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "libzim";
  version = "9.3.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    tag = version;
    hash = "sha256-DZiFeZ2ry3JpXDs3mvf0q7diwhkjQ2730KQkDQPbgcY=";
  };

  patches = [
    # Upstream patch for ICU76 compatibility.
    # https://github.com/openzim/libzim/pull/936
    (fetchpatch {
      url = "https://github.com/openzim/libzim/commit/4a42b3c6971c9534b104f48f6d13db8630a97d2f.patch";
      hash = "sha256-FjaGZ2bI1ROLg3rvWIGLbVoImGr51MbWjbBj+lGj1rs=";
    })
  ];

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zstd
  ];

  propagatedBuildInputs = [
    xapian
    xz
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  mesonFlags = [
    # Tests are located at https://github.com/openzim/zim-testing-suite
    # "...some tests need up to 16GB of memory..."
    "-Dtest_data_dir=none"
  ];

  meta = {
    description = "Reference implementation of the ZIM specification";
    homepage = "https://github.com/openzim/libzim";
    changelog = "https://github.com/openzim/libzim/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      fab
      greg
    ];
  };
}
