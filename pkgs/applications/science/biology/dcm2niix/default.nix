{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, makeBinaryWrapper
, cmake
, openjpeg
, pigz
, yaml-cpp
, zlib
, batchVersion ? false
, withJpegLs ? true
, withOpenJpeg ? true
, withPigz ? false
, withCloudflareZlib ? false
}:

let
  cloudflareZlib = fetchFromGitHub {
    owner = "cloudflare";
    repo = "zlib";
    # HEAD revision of the gcc.amd64 branch on 2024-07-04. Reminder to update
    # whenever bumping package version.
    rev = "92530568d2c128b4432467b76a3b54d93d6350bd";
    hash = "sha256-rkbh1I+ZL97F0vATVcuo/mk9ZGJxKMhP4dj9Mz3dtys=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.0.20240202";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vJUPv/6KNCsU8UjwfktHdTlsweG7+UGgAEZeESfBkD8=";
  };

  patches = [
    ./dont-use-git.patch
  ] ++ lib.optionals withCloudflareZlib [
    (substituteAll {
      src = ./dont-fetch-external-libs.patch;
      inherit cloudflareZlib;
    })
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];
  buildInputs = [ zlib ] ++ lib.optionals batchVersion [ yaml-cpp ]
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
  ] ++ lib.optionals (!withCloudflareZlib) [
    "-DZLIB_IMPLEMENTATION=System"
  ];

  postInstall = lib.optionalString withPigz ''
    wrapProgram $out/bin/dcm2niix --set PATH "${lib.makeBinPath [ pigz ]}"
  '';

  meta = {
    description = "DICOM to NIfTI converter";
    mainProgram = "dcm2niix";
    longDescription = ''
      dcm2niix is designed to convert neuroimaging data from the DICOM format to the NIfTI format.
    '';
    homepage = "https://www.nitrc.org/projects/dcm2nii";
    changelog = "https://github.com/rordenlab/dcm2niix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman rbreslow ];
    platforms = lib.platforms.all;
  };
})
