{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, macdylibbundler
, makeWrapper
, darwin
, codec2
, libpulseaudio
, libsamplerate
, libsndfile
, lpcnetfreedv
, portaudio
, speexdsp
, hamlib_4
, wxGTK32
, sioclient
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, AppKit
, AVFoundation
, Cocoa
, CoreMedia
}:

stdenv.mkDerivation rec {
  pname = "freedv";
  version = "1.9.7.2";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
    hash = "sha256-JbLP65fC6uHrHXpSUwtgYHB+VLfheo5RU3C44lx8QlQ=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "-Wl,-ld_classic" ""
    substituteInPlace src/CMakeLists.txt \
      --replace "\''${CMAKE_SOURCE_DIR}/macdylibbundler/dylibbundler" "dylibbundler"
    sed -i "/codesign/d;/hdiutil/d" src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    macdylibbundler
    makeWrapper
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnetfreedv
    speexdsp
    hamlib_4
    wxGTK32
    sioclient
  ] ++ (if pulseSupport then [ libpulseaudio ] else [ portaudio ])
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    AVFoundation
    Cocoa
    CoreMedia
  ];

  cmakeFlags = [
    "-DUSE_INTERNAL_CODEC2:BOOL=FALSE"
    "-DUSE_STATIC_DEPS:BOOL=FALSE"
    "-DUNITTEST=ON"
    "-DUSE_PULSEAUDIO:BOOL=${if pulseSupport then "TRUE" else "FALSE"}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    "-DAPPLE_OLD_XCODE"
  ]);

  doCheck = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/FreeDV.app $out/Applications
    makeWrapper $out/Applications/FreeDV.app/Contents/MacOS/FreeDV $out/bin/freedv
  '';

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mvs wegank ];
    platforms = platforms.unix;
  };
}
