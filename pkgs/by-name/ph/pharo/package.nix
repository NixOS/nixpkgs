{
  lib,
  stdenv,
  cairo,
  cmake,
  fetchzip,
  freetype,
  libffi,
  libgit2,
  libpng,
  libuuid,
  makeBinaryWrapper,
  openssl,
  pixman,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pharo";
  version = "10.3.4+3.884643b";

  src = fetchzip {
    # It is necessary to download from there instead of from the repository because that archive
    # also contains artifacts necessary for the bootstrapping.
    url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/PharoVM-v${finalAttrs.version}-Linux-x86_64-c-src.zip";
    hash = "sha256-JBN0gPVMIUFzrdLqrCnCvf4cbZMfpluO2/jCxk3U+M8=";
  };

  strictDeps = true;

  buildInputs = [
    cairo
    freetype
    libffi
    libgit2
    libpng
    libuuid
    openssl
    pixman
    SDL2
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  cmakeFlags = [
    # Necessary to perform the bootstrapping without already having Pharo available.
    "-DGENERATED_SOURCE_DIR=."
    "-DALWAYS_INTERACTIVE=ON"
    "-DBUILD_IS_RELEASE=ON"
    "-DGENERATE_SOURCES=OFF"
    # Prevents CMake from trying to download stuff.
    "-DBUILD_BUNDLE=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-incompatible-pointer-types"
  ];

  # Fix missing version.info
  preBuild = ''
    mkdir -p /build/source/build/
    echo "${finalAttrs.version}" > /build/source/build/version.info
  '';

  installPhase = ''
    runHook preInstall

    cmake --build . --target=install
    mkdir -p "$out/lib"
    mkdir "$out/bin"
    cp build/vm/*.so* "$out/lib/"
    cp build/vm/pharo "$out/bin/pharo"

    runHook postInstall
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath (
        finalAttrs.buildInputs
        ++ [
          stdenv.cc.cc
          "$out"
        ]
      );
    in
    ''
      patchelf --allowed-rpath-prefixes "$NIX_STORE" --shrink-rpath "$out/bin/pharo"
      ln -s "${libgit2}/lib/libgit2.so" $out/lib/libgit2.so.1.1
      wrapProgram "$out/bin/pharo" --argv0 $out/bin/pharo --prefix LD_LIBRARY_PATH ":" "${libPath}"
    '';

  meta = {
    description = "Clean and innovative Smalltalk-inspired environment";
    homepage = "https://pharo.org";
    changelog = "https://github.com/pharo-project/pharo/releases/";
    license = lib.licenses.mit;
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.
    '';
    mainProgram = "pharo";
    platforms = lib.platforms.linux;
  };
})
