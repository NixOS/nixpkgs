{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libarcus,
  stb,
  protobuf,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "4.13.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "sha256-dx0Q6cuA66lG4nwR7quW5Tvs9sdxjdV4gtpxXirI4nY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libarcus
    stb
    protobuf
  ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  # TODO already fixed in master, remove in next release
  patches = [
    (fetchpatch {
      url = "https://github.com/Ultimaker/CuraEngine/commit/de60e86a6ea11cb7d121471b5dd192e5deac0f3d.patch";
      hash = "sha256-/gT9yErIDDYAXvZ6vX5TGlwljy31K563+sqkm1UGljQ=";
      includes = [ "src/utils/math.h" ];
    })
  ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      abbradar
      gebner
    ];
    mainProgram = "CuraEngine";
  };
}
