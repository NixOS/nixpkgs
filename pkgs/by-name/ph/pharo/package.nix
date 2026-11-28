{
  lib,
  stdenv,
  cairo,
  cmake,
  fetchzip,
  freetype,
  git,
  libffi,
  libgit2,
  libpng,
  libuuid,
  makeBinaryWrapper,
  openssl,
  pixman,
  SDL2,
  common-updater-scripts,
  versionCheckHook,
  writeShellScript,
}:

let
  # Short commit of the release tag, upstream puts it in the source file name.
  commit = "b3d41c1";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pharo";
  version = "10.3.13";

  src = fetchzip {
    # It is necessary to download from there instead of from the repository because that archive
    # also contains artifacts necessary for the bootstrapping.
    url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/PharoVM-v${finalAttrs.version}+0.${commit}-Linux-x86_64-c-src.zip";
    hash = "sha256-maScANPHH84hfQCFesKaYAQsjmmy5WxA0zuZ38o+wWs=";
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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

  passthru.updateScript = writeShellScript "update-pharo" ''
    set -euo pipefail
    file=pkgs/by-name/ph/pharo/package.nix
    read -r sha ref < <(${lib.getExe git} ls-remote --tags --refs https://github.com/pharo-project/pharo-vm 'v10.3.*' | sort -V -k2 | tail -n 1)
    version=''${ref##*/v}
    sed -i "s/commit = \".*\";/commit = \"''${sha:0:7}\";/" "$file"
    ${lib.getExe' common-updater-scripts "update-source-version"} pharo "$version" --ignore-same-version
  '';

  meta = {
    description = "Clean and innovative Smalltalk-inspired environment";
    homepage = "https://pharo.org";
    changelog = "https://github.com/pharo-project/pharo-vm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.
    '';
    mainProgram = "pharo";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samirbgno ];
  };
})
