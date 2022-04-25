{ lib
, stdenv
, fetchFromGitHub
, callPackage
, substituteAll
, cmake
, openjpeg
, libyamlcpp
, batchVersion ? false
, withJpegLs ? true
, withOpenJpeg ? true
, withCloudflareZlib ? true
}:

let
  cloudflareZlib = fetchFromGitHub {
    owner = "ningfei";
    repo = "zlib";
    # HEAD revision of the gcc.amd64 branch on 2022-04-14. Reminder to update
    # whenever bumping package version.
    rev = "fda61188d1d4dcd21545c34c2a2f5cc9b0f5db4b";
    sha256 = "sha256-qySFwY0VI2BQLO2XoCZeYshXEDnHh6SmJ3MvcBUROWU=";
  };
in
stdenv.mkDerivation rec {
  version = "1.0.20211006";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "sha256-fQAVOzynMdSLDfhcYWcaXkFW/mnv4zySGLVJNE7ql/c=";
  };

  patches = lib.optionals withCloudflareZlib [
    (substituteAll {
      src = ./dont-fetch-external-libs.patch;
      inherit cloudflareZlib;
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals batchVersion [ libyamlcpp ]
    ++ lib.optionals withOpenJpeg [ openjpeg openjpeg.dev ];

  cmakeFlags = lib.optionals batchVersion [
    "-DBATCH_VERSION=ON"
    "-DYAML-CPP_DIR=${libyamlcpp}/lib/cmake/yaml-cpp"
  ] ++ lib.optionals withJpegLs [
    "-DUSE_JPEGLS=ON"
  ] ++ lib.optionals withOpenJpeg [
    "-DUSE_OPENJPEG=ON"
    "-DOpenJPEG_DIR=${openjpeg}/lib/${openjpeg.pname}-${lib.versions.majorMinor openjpeg.version}"
  ] ++ lib.optionals withCloudflareZlib [
    "-DZLIB_IMPLEMENTATION=Cloudflare"
  ];

  passthru.tests = {
    dcm-qa = callPackage ./tests/dicom-validation {
      name = "${pname}-dcm-qa";

      src = fetchFromGitHub {
        owner = "neurolabusc";
        repo = "dcm_qa";
        # HEAD revision of the master branch on 2022-04-19.
        rev = "bb457d98bdb320af3b9f29fad1c706788490dab8";
        sha256 = "sha256-rlfChr/A45x1oxozZJxozS/rHUfXlLgmERDpPAx8LKA=";
      };
    };
    dcm-qa-nih = callPackage ./tests/dicom-validation {
      name = "${pname}-dcm-qa-nih";

      src = fetchFromGitHub {
        owner = "neurolabusc";
        repo = "dcm_qa_nih";
        # HEAD revision of the master branch on 2022-04-19.
        rev = "aa82e560d5471b53f0d0332c4de33d88bf179157";
        sha256 = "sha256-4Yjgs7UnpFv5KjVqWQXdfhKDhaSKQp7PUghmMoWC5KU=";
      };
    };
    dcm-qa-uih = callPackage ./tests/dicom-validation {
      name = "${pname}-dcm-qa-uih";

      src = fetchFromGitHub {
        owner = "neurolabusc";
        repo = "dcm_qa_uih";
        # HEAD revision of the master branch on 2022-04-19.
        rev = "4c0e2b37430fa566a501bb65f35a9ad4089e71a9";
        sha256 = "sha256-TtBfgL8XWUozS3XKFa4DVzM4y0o58oR9E56f7ANSDP4=";
      };
    };
  };

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
