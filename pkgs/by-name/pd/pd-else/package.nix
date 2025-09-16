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
  version = "1.0-rc13";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-else";
    tag = "v.${version}";
    hash = "sha256-WebjdozcFup2xk3cS9LPTiA6m0l1sR6sj3hHlt6ScfU=";
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
      --replace-fail 'target_link_libraries(sfload PRIVATE ffmpeg)' 'target_link_libraries(sfload PRIVATE avformat avcodec avutil swresample z)' \
      --replace-fail 'target_link_libraries(sfinfo PRIVATE ffmpeg)' 'target_link_libraries(sfinfo PRIVATE avformat avcodec avutil swresample z)'
  '';

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-I${puredata}/include/pd"
    "-DCMAKE_CXX_FLAGS=-I${puredata}/include/pd"
    "-DUSE_LTO=ON"
    "-DOPENSSL_CRYPTO_LIBRARY=${lib.getLib openssl}/lib/libcrypto.so"
    "-DOPENSSL_SSL_LIBRARY=${lib.getLib openssl}/lib/libssl.so"
  ];

  postInstall = ''
    mv else/ $out/else/
    rm -rf $out/include/ $out/lib/
  '';

  postFixup = ''
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    find $out -type f -executable -exec patchelf --set-interpreter "$interpreter" --set-rpath ${lib.makeLibraryPath buildInputs} {} \;
  '';

  meta = {
    description = "EL Locus Solus' Externals for Pure Data";
    longDescription = ''
      ELSE is a library of externals and abstractions for Pure Data.
      It provides a comprehensive set of tools for signal processing,
      MIDI, GUI, and more in Pure Data.
    '';
    homepage = "https://github.com/porres/pd-else";
    license = lib.licenses.wtfpl;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ lib.maintainers.kugland ];
  };
}
