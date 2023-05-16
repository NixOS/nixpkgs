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
<<<<<<< HEAD
, sioclient
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, AppKit
, AVFoundation
, Cocoa
, CoreMedia
}:

stdenv.mkDerivation rec {
  pname = "freedv";
<<<<<<< HEAD
  version = "1.9.1";
=======
  version = "1.8.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4bkT853MZL6v0/PRh0RJBhqdFBXgWFSPDtIPLgcKR8A=";
=======
    hash = "sha256-HDHXVTkXC1fCqj4lnxURmXvQNtwDX4zA6/QFnYceUI4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
      --replace "\''${CMAKE_SOURCE_DIR}/macdylibbundler/dylibbundler" "dylibbundler"
    sed -i "/hdiutil/d" src/CMakeLists.txt
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
<<<<<<< HEAD
    sioclient
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "-DUSE_PULSEAUDIO:BOOL=${if pulseSupport then "TRUE" else "FALSE"}"
  ];
=======
  ] ++ lib.optionals pulseSupport [ "-DUSE_PULSEAUDIO:BOOL=TRUE" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
