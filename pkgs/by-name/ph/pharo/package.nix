{ lib
, stdenv
, cairo
, cmake
, fetchzip
, freetype
, libffi
, libgit2
, libpng
, libuuid
, makeBinaryWrapper
, openssl
, pixman
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pharo";
  version = "10.0.9-de76067";

  src = fetchzip {
    # It is necessary to download from there instead of from the repository because that archive
    # also contains artifacts necessary for the bootstrapping.
    url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/PharoVM-${finalAttrs.version}-Linux-x86_64-c-src.zip";
    hash = "sha256-INeQGYCxBu7DvFmlDRXO0K2nhxcd9K9Xwp55iNdlvhk=";
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

  installPhase =
    let
      library_path = lib.strings.makeLibraryPath [
        "$out"
        cairo
        freetype
        libgit2
        SDL2
      ];
    in
    ''
      runHook preInstall

      cmake --build . --target=install
      mkdir -p "$out/lib"
      mkdir "$out/bin"
      cp build/vm/*.so* "$out/lib/"
      cp build/vm/pharo "$out/bin/pharo"
      patchelf --allowed-rpath-prefixes "$NIX_STORE" --shrink-rpath "$out/bin/pharo"
      wrapProgram "$out/bin/pharo" --set LD_LIBRARY_PATH "${library_path}"

      runHook postInstall
    '';

  meta = {
    description = "Clean and innovative Smalltalk-inspired environment";
    homepage = "https://pharo.org";
    license = lib.licenses.mit;
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.
    '';
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "pharo";
    platforms = lib.platforms.linux;
  };
})
