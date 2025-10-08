{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  cmake,
  rtl-sdr,
  libao,
  fftwFloat,
}:
let
  src_faad2 = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    tag = "2.11.2";
    hash = "sha256-JvmblrmE3doUMUwObBN2b+Ej+CDBWNemBsyYSCXGwo8=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "nrsc5";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "theori-io";
    repo = "nrsc5";
    rev = "v${finalAttrs.version}";
    hash = "sha256-chLoCXbEQaIrSHLQAm0++NGNYuQNCseSCR37qjXwW04=";
  };

  postUnpack = ''
    export srcRoot=`pwd`
    export faadSrc="$srcRoot/faad2-prefix/src/faad2_external"
    mkdir -p $faadSrc
    cp -r ${src_faad2}/* $faadSrc
    chmod -R u+w $faadSrc
  '';

  postPatch = ''
    sed -i '/GIT_REPOSITORY/d' CMakeLists.txt
    sed -i '/GIT_TAG/d' CMakeLists.txt
    sed -i "s:set (FAAD2_PREFIX .*):set (FAAD2_PREFIX \"$srcRoot/faad2-prefix\"):" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    rtl-sdr
    libao
    fftwFloat
  ];

  cmakeFlags = [
    "-DUSE_COLOR=ON"
    "-DUSE_FAAD2=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/theori-io/nrsc5";
    description = "HD-Radio decoder for RTL-SDR";
    platforms = lib.platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ markuskowa ];
    mainProgram = "nrsc5";
  };
})
