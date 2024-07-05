{ lib, stdenv, fetchFromGitHub, cmake, zlib, libglvnd, libGLU, wrapQtAppsHook
, sshSupport ? true, openssl, libssh
, tetgenSupport ? true, tetgen
, ffmpegSupport ? true, ffmpeg_4
, dicomSupport  ? false, dcmtk
, withModelRepo ? true
, withCadFeatures ? false
}:

stdenv.mkDerivation rec {
  pname = "febio-studio";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBioStudio";
    rev = "v${version}";
    sha256 = "0r6pg49i0q9idp7pjymj7mlxd63qjvmfvg0l7fmx87y1yd2hfw4h";
  };

  patches = [
    ./febio-studio-cmake.patch # Fix Errors that appear with certain Cmake flags
  ];

  cmakeFlags = [
    "-DQt_Ver=5"
    "-DNOT_FIRST=On"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ]
    ++ lib.optional sshSupport "-DUSE_SSH=On"
    ++ lib.optional tetgenSupport "-DUSE_TETGEN=On"
    ++ lib.optional ffmpegSupport "-DUSE_FFMPEG=On"
    ++ lib.optional dicomSupport "-DUSE_DICOM=On"
    ++ lib.optional withModelRepo "-DMODEL_REPO=On"
    ++ lib.optional withCadFeatures "-DCAD_FEATURES=On"
  ;


  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R bin $out/
    runHook postInstall
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ zlib libglvnd libGLU openssl libssh ]
    ++ lib.optional sshSupport openssl
    ++ lib.optional tetgenSupport tetgen
    ++ lib.optional ffmpegSupport ffmpeg_4
    ++ lib.optional dicomSupport dcmtk
  ;

  meta = with lib; {
    description = "FEBio Suite Solver";
    mainProgram = "FEBioStudio";
    license = with licenses; [ mit ];
    homepage = "https://febio.org/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
