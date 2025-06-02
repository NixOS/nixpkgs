{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
  pkg-config,
  cmake,
  openssl,
  libogg,
  libvorbis,
  opusfile,
  ffmpeg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "pd-else";
  version = "1.0-beta";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-else";
    rev = "1.0-beta";
    hash = "sha256-PndIy5fDK5f4wkd0noLJHT6IIzYP8QRBLC0+tPnaDek=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    puredata
    openssl
    libogg
    libvorbis
    opusfile
    ffmpeg
    zlib
  ];

  # Set up Pure Data headers and configure with system libraries
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(Source/Shared/ffmpeg)' '# add_subdirectory(Source/Shared/ffmpeg) - using system FFmpeg' \
      --replace-fail 'target_link_libraries(play.file_tilde PRIVATE ffmpeg)' 'target_link_libraries(play.file_tilde PRIVATE avformat avcodec avutil swresample z)' \
      --replace-fail 'target_link_libraries(streamin_tilde PRIVATE ffmpeg)' 'target_link_libraries(streamin_tilde PRIVATE avformat avcodec avutil swresample z)' \
      --replace-fail 'target_link_libraries(streamout_tilde PRIVATE ffmpeg)' 'target_link_libraries(streamout_tilde PRIVATE avformat avcodec avutil swresample z)' \
      --replace-fail 'target_link_libraries(sfload PRIVATE ffmpeg)' 'target_link_libraries(sfload PRIVATE avformat avcodec avutil swresample z)' \
      --replace-fail 'target_link_libraries(sfinfo PRIVATE ffmpeg)' 'target_link_libraries(sfinfo PRIVATE avformat avcodec avutil swresample z)'
  '';

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-I${puredata}/include/pd"
    "-DCMAKE_CXX_FLAGS=-I${puredata}/include/pd"
    "-DUSE_LTO=ON"
    "-DOPENSSL_CRYPTO_LIBRARY=${openssl.out}/lib/libcrypto.so"
    "-DOPENSSL_SSL_LIBRARY=${openssl.out}/lib/libssl.so"
  ];

  postInstall = ''
    mv else/ $out/else/
    rm -rf $out/include/ $out/lib/
  '';

  postFixup = ''
    # Patch binaries.
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    find $out -type f -executable -exec patchelf --set-interpreter $interpreter --set-rpath ${lib.makeLibraryPath buildInputs} {} \;
  '';

  meta = with lib; {
    description = "ELSE - EL Locus Solus' Externals for Pure Data";
    longDescription = ''
      ELSE is a library of externals and abstractions for Pure Data.
      It provides a comprehensive set of tools for signal processing,
      MIDI, GUI, and more in Pure Data.
    '';
    homepage = "https://github.com/porres/pd-else";
    license = licenses.wtfpl;
    platforms = platforms.unix;
    maintainers = [ lib.maintainers.kugland ];
  };
}
