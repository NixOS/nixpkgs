{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, cmake
, openjpeg
, yaml-cpp
, batchVersion ? false
, withJpegLs ? true
, withOpenJpeg ? true
, withCloudflareZlib ? true
}:

let
  cloudflareZlib = fetchFromGitHub {
    owner = "ningfei";
    repo = "zlib";
    # HEAD revision of the gcc.amd64 branch on 2023-03-28. Reminder to update
    # whenever bumping package version.
    rev = "f49b13c3380cf9677ae9a93641ebc6f770899def";
    sha256 = "sha256-8HNFUGx2uuEb8UrGUiqkN+uVDX83YIisT2uO1Z7GCxc=";
  };
in
stdenv.mkDerivation rec {
  version = "1.0.20230411";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "sha256-kOVEoqrk4l6sH8iDVx1QmOYP5tCufxsWnCnn9BibZ08=";
  };

  patches = lib.optionals withCloudflareZlib [
    (substituteAll {
      src = ./dont-fetch-external-libs.patch;
      inherit cloudflareZlib;
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals batchVersion [ yaml-cpp ]
    ++ lib.optionals withOpenJpeg [ openjpeg openjpeg.dev ];

  cmakeFlags = lib.optionals batchVersion [
    "-DBATCH_VERSION=ON"
    "-DYAML-CPP_DIR=${yaml-cpp}/lib/cmake/yaml-cpp"
  ] ++ lib.optionals withJpegLs [
    "-DUSE_JPEGLS=ON"
  ] ++ lib.optionals withOpenJpeg [
    "-DUSE_OPENJPEG=ON"
    "-DOpenJPEG_DIR=${openjpeg}/lib/${openjpeg.pname}-${lib.versions.majorMinor openjpeg.version}"
  ] ++ lib.optionals withCloudflareZlib [
    "-DZLIB_IMPLEMENTATION=Cloudflare"
  ];

  meta = with lib; {
    description = "DICOM to NIfTI converter";
    mainProgram = "dcm2niix";
    longDescription = ''
      dcm2niix is designed to convert neuroimaging data from the DICOM format to the NIfTI format.
    '';
    homepage = "https://www.nitrc.org/projects/dcm2nii";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman rbreslow ];
    platforms = platforms.all;
  };
}
