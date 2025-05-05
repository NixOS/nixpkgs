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
    owner = "dsvensson";
    repo = "faad2";
    rev = "b7aa099fd3220b71180ed2b0bc19dc6209a1b418";
    sha256 = "0pcw2x9rjgkf5g6irql1j4m5xjb4lxj6468z8v603921bnir71mf";
  };

  version = "1.0";

in
stdenv.mkDerivation {
  pname = "nrsc5";
  inherit version;

  src = fetchFromGitHub {
    owner = "theori-io";
    repo = "nrsc5";
    rev = "v${version}";
    sha256 = "09zzh3h1zzf2lwrbz3i7rif2hw36d9ska8irvxaa9lz6xc1y68pg";
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
    # see https://github.com/dsvensson/faad2/pull/2
    substituteInPlace $faadSrc/libfaad/pns.c \
      --replace-fail 'r1_dep = __r1;' 'r1_dep = *__r1;' \
      --replace-fail 'r2_dep = __r2;' 'r2_dep = *__r2;'
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
}
