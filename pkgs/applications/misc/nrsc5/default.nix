{ stdenv, fetchFromGitHub,
  autoconf, automake, libtool, cmake,
  rtl-sdr, libao, fftwFloat
} :
let
  src_faad2 = fetchFromGitHub {
    owner = "dsvensson";
    repo = "faad2";
    rev = "b7aa099fd3220b71180ed2b0bc19dc6209a1b418";
    sha256 = "0pcw2x9rjgkf5g6irql1j4m5xjb4lxj6468z8v603921bnir71mf";
  };

in stdenv.mkDerivation {
  name = "nrsc5-20171129";

  src = fetchFromGitHub {
    owner = "theori-io";
    repo = "nrsc5";
    rev = "f87beeed96f12ce6aa4789ac1d45761cec28d2db";
    sha256 = "03d5k59125qrjsm1naj9pd0nfzwi008l9n30p9q4g5abgqi5nc8v";
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

  nativeBuildInputs = [ cmake autoconf automake libtool ];
  buildInputs = [ rtl-sdr libao fftwFloat ];

  cmakeFlags = [ "-DUSE_COLOR=ON" "-DUSE_FAAD2=ON" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/theori-io/nrsc5;
    description = "HD-Radio decoder for RTL-SDR";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ markuskowa ];
  };
}

