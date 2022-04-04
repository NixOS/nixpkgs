{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
, openjpeg
, libyamlcpp
, zlib
, batchVersion ? false
, withJpegLs ? true
, withOpenJpeg ? true
, withSystemZlib ? true
}:

stdenv.mkDerivation rec {
  version = "1.0.20211006";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "sha256-fQAVOzynMdSLDfhcYWcaXkFW/mnv4zySGLVJNE7ql/c=";
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = lib.optionals batchVersion [ libyamlcpp ]
    ++ lib.optionals withOpenJpeg [ openjpeg openjpeg.dev ]
    ++ lib.optionals withSystemZlib [ zlib ];

  cmakeFlags = lib.optionals batchVersion [
      "-DBATCH_VERSION=ON"
      "-DYAML-CPP_DIR=${libyamlcpp}/lib/cmake/yaml-cpp"
    ] ++ lib.optionals withJpegLs [
      "-DUSE_JPEGLS=ON"
    ] ++ lib.optionals withOpenJpeg [
      "-DUSE_OPENJPEG=ON"
      "-DOpenJPEG_DIR=${openjpeg}/lib/${openjpeg.pname}-${lib.versions.majorMinor openjpeg.version}"
    ] ++ lib.optionals withSystemZlib [
      "-DZLIB_IMPLEMENTATION=System"
    ];

  meta = with lib; {
    description = "DICOM to NIfTI converter";
    longDescription = ''
      dcm2niix is designed to convert neuroimaging data from the DICOM format to the NIfTI format.
    '';
    homepage = "https://www.nitrc.org/projects/dcm2nii";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman rbreslow ];
    platforms = platforms.all;
  };
}
