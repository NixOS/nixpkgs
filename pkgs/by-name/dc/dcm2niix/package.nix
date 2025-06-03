{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  replaceVars,
  cmake,
  openjpeg,
  pigz,
  yaml-cpp,
  batchVersion ? false,
  withJpegLs ? true,
  withOpenJpeg ? true,
  withPigz ? true,
  withCloudflareZlib ? true,
}:

let
  cloudflareZlib = fetchFromGitHub {
    owner = "ningfei";
    repo = "zlib";
    # HEAD revision of the gcc.amd64 branch on 2025-01-05. Reminder to update
    # whenever bumping package version.
    rev = "1cb075520d254005cde193982f1856b877fd39d8";
    hash = "sha256-1+V7XwYOYqSzcFK86V+gDILGwAqKGQ+HSlXphWtqSvk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.0.20241211";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NpvtMCcyVfYlnvXjyvTDsa71IxUhi8FepX82qRSG7TA=";
  };

  patches = lib.optionals withCloudflareZlib [
    (replaceVars ./dont-fetch-external-libs.patch {
      inherit cloudflareZlib;
    })
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  buildInputs =
    lib.optionals batchVersion [ yaml-cpp ]
    ++ lib.optionals withOpenJpeg [
      openjpeg
      openjpeg.dev
    ];

  cmakeFlags =
    lib.optionals batchVersion [
      "-DBATCH_VERSION=ON"
      "-DYAML-CPP_DIR=${yaml-cpp}/lib/cmake/yaml-cpp"
    ]
    ++ lib.optionals withJpegLs [
      "-DUSE_JPEGLS=ON"
    ]
    ++ lib.optionals withOpenJpeg [
      "-DUSE_OPENJPEG=ON"
      "-DOpenJPEG_DIR=${openjpeg}/lib/${openjpeg.pname}-${lib.versions.majorMinor openjpeg.version}"
    ]
    ++ lib.optionals withCloudflareZlib [
      "-DZLIB_IMPLEMENTATION=Cloudflare"
    ];

  postInstall = lib.optionalString withPigz ''
    wrapProgram $out/bin/dcm2niix --prefix PATH : "${lib.makeBinPath [ pigz ]}"
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
    maintainers = with lib.maintainers; [
      ashgillman
      rbreslow
    ];
    platforms = lib.platforms.all;
  };
})
