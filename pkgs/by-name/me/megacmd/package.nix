{
  lib,
  stdenv,
  cmake,
  cryptopp,
  curl,
  fetchFromGitHub,
  file,
  ffmpeg,
  fuse,
  icu,
  libmediainfo,
  libsodium,
  libuv,
  libzen,
  makeWrapper,
  nix-update-script,
  pdfium-binaries,
  pkg-config,
  readline,
  sqlite,
  versionCheckHook,
  writeShellScriptBin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "megacmd";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    # The upstream makes a tag for each platform getting a release,
    # but the tags all point to the same commit,
    # so we just stick to the Linux tag to make the update script easy.
    tag = "${finalAttrs.version}_Linux";
    fetchSubmodules = true;
    postCheckout = "git -C $out/sdk rev-parse --short HEAD > $out/sdk/.gitrev";
    hash = "sha256-RE4n4igAXhYNshnjjyeb2McmBKt5HY0oZ+U5SMMtQ2I=";
  };

  __structuredAttrs = true;

  patches = [
    # use pkg-config instead of vcpkg
    # https://github.com/meganz/MEGAcmd/pull/1067
    ./no-vcpkg.patch

    # use cmake option to enable the updater instead of depending on os
    # https://github.com/meganz/MEGAcmd/pull/1117
    ./disable-updater.patch

    # fix install paths (/usr/bin -> /bin on linux, and / -> /Applications on darwin)
    ./install-path.patch

    # do not look for the mega-cmd-server executable in /Applications on darwin
    # but use the same strategy as on linux
    ./fix-darwin.patch
  ];

  postPatch = ''
    # interesting typo (https://github.com/meganz/MEGAcmd/pull/1118, https://github.com/meganz/sdk/pull/2770)
    substituteInPlace build/cmake/modules/megacmd_configuration.cmake sdk/cmake/modules/configuration.cmake \
      --replace-fail "check_function_exists(aio_write, HAVE_AIO_RT)" "check_function_exists(aio_write HAVE_AIO_RT)"

    # cryptopp on nixpkgs has libcryptopp.pc, not libcrypto++.pc
    # pdfium-binaries{,-v8} in nixpkgs does not provide a pc file but only a cmake file
    # libicui18n is needed (https://github.com/meganz/sdk/pull/2769)
    substituteInPlace sdk/cmake/modules/sdklib_libraries.cmake \
      --replace-fail "pkg_check_modules(cryptopp REQUIRED IMPORTED_TARGET libcrypto++)" "pkg_check_modules(cryptopp REQUIRED IMPORTED_TARGET libcryptopp)" \
      --replace-fail "pkg_check_modules(pdfium REQUIRED IMPORTED_TARGET pdfium)" "find_package(PDFium)" \
      --replace-fail "target_link_libraries(SDKlib PRIVATE PkgConfig::pdfium)" "target_link_libraries(SDKlib PRIVATE pdfium)" \
      --replace-fail "find_package(ICU COMPONENTS uc data REQUIRED)" "find_package(ICU COMPONENTS i18n uc data REQUIRED)" \
      --replace-fail "target_link_libraries(SDKlib PRIVATE ICU::uc ICU::data)" "target_link_libraries(SDKlib PRIVATE ICU::i18n ICU::uc ICU::data)"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    file
    makeWrapper

    # https://github.com/meganz/MEGAcmd/blob/2.5.0_Linux/CMakeLists.txt#L4-L10
    (writeShellScriptBin "git" ''
      dir="$(pwd)"
      while [[ ! -f "$dir/.gitrev" ]]; do
        if [[ "$dir" == "/" ]]; then
          echo "fatal: not a git repository (or any of the parent directories): .git" >&2
          exit 128
        fi
        dir="$(dirname "$dir")"
      done
      cat "$dir/.gitrev"
    '')
  ];

  buildInputs = [
    cryptopp
    curl
    ffmpeg
    fuse
    icu
    libmediainfo
    libsodium
    libuv
    libzen
    pdfium-binaries
    readline
    sqlite
  ];

  cmakeFlags = [
    (lib.cmakeFeature "VCPKG_ROOT" "") # fallback to pkg-config instead of vcpkg
    (lib.cmakeBool "ENABLE_UPDATER" false)
    (lib.cmakeBool "USE_FREEIMAGE" false) # freeimage was removed from nixpkgs
    (lib.cmakeBool "USE_PCRE" false) # causes link errors and is not needed anyway (use std::regex instead)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    for bundle in $out/Applications/*.app; do
      ln -s "$bundle/Contents/MacOS"/* -t $out/bin
    done

    # this command has different names (linux: mega-cmd-server; macos: MEGAcmd; windows: MEGAcmdServer)
    # NOTE: official documentation (https://help.mega.io/desktop-app/mega-cmd/cmd) is outdated about this
    ln -s $out/bin/MEGAcmd $out/bin/mega-cmd-server

    # these commands are installed on linux but not on macos
    install -Dm755 ../src/client/mega-* -t $out/bin
  '';

  preFixup = ''
    # use mega-exec from the same package instead of the one from PATH to avoid version mismatch
    for f in $out/bin/*; do
      if [[ "$(file -b --mime-type "$f")" == text/* ]]; then # shell script
        substituteInPlace "$f" --replace-fail mega-exec "exec $out/bin/mega-exec"
      elif [[ -f "$f" ]]; then # binary executable and not symlink
        wrapProgram "$f" --prefix PATH : $out/bin${
          # there are some rpath problems on darwin that causes the binaries unable to find shared libraries
          # there is probably a better way to fix this, but I cannot find it out
          # everything in buildInputs is needed
          lib.optionalString stdenv.hostPlatform.isDarwin
            " --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}"
        }
      fi
    done
  '';

  # mega-exec wants to connect to megacmd server
  __darwinAllowLocalNetworking = finalAttrs.doInstallCheck;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mega-version";
  versionCheckProgramArg = "-l";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=(\\d+\\.\\d+\\.\\d+)_Linux" ];
  };

  meta = {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.io/cmd";
    changelog = "https://github.com/meganz/MEGAcmd/blob/${finalAttrs.src.tag}/build/megacmd/megacmd.changes";
    license = with lib.licenses; [
      bsd2
      gpl3Only
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      lunik1
      ulysseszhan
    ];
    mainProgram = "mega-cmd";
  };
})
