{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  cmake,
  copyDesktopItems,
  pkg-config,
  qt6Packages,
  linyaps-box,
  cli11,
  curl,
  gpgme,
  gtest,
  libarchive,
  libelf,
  libsodium,
  libsysprof-capture,
  nlohmann_json,
  openssl,
  ostree,
  systemdLibs,
  tl-expected,
  uncrustify,
  xz,
  yaml-cpp,
  replaceVars,
  bash,
  binutils,
  coreutils,
  desktop-file-utils,
  erofs-utils,
  fuse3,
  fuse-overlayfs,
  gnutar,
  glib,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-C5rP6r3V+hxTjM+kmXjS4MnuL6P5wxSVP9nNmlQbcB8=";
  };

  patches = [
    ./fix-host-path.patch
  ];

  postPatch = ''
    substituteInPlace apps/ll-init/CMakeLists.txt \
      --replace-fail "target_link_options(\''${LL_INIT_TARGET} PRIVATE -static -static-libgcc" \
                     "target_link_options(\''${LL_INIT_TARGET} PRIVATE -static -static-libgcc -L${stdenv.cc.libc.static}/lib"

    substituteInPlace misc/share/applications/linyaps.desktop \
      --replace-fail "/usr/bin/ll-cli" "$out/bin/ll-cli"

    # Don't use hardcoded paths in the application's desktop file, as it would become invalid when the old linyaps gets removed.
    substituteInPlace libs/linglong/src/linglong/repo/ostree_repo.cpp \
      --replace-fail 'LINGLONG_CLIENT_PATH' 'LINGLONG_CLIENT_NAME'
  '';

  buildInputs = [
    cli11
    curl
    gpgme
    gtest
    libarchive
    libelf
    libsodium
    libsysprof-capture
    nlohmann_json
    openssl
    ostree
    qt6Packages.qtbase
    systemdLibs
    tl-expected
    uncrustify
    xz
    yaml-cpp
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    pkg-config
    qt6Packages.wrapQtAppsNoGuiHook
  ];

  postInstall = ''
    # move to the right location for systemd.packages option
    # https://github.com/NixOS/nixpkgs/blob/85dbfc7aaf52ecb755f87e577ddbe6dbbdbc1054/nixos/modules/system/boot/systemd.nix#L605
    mv $out/lib/systemd/system-environment-generators $out/lib/systemd/system-generators
  '';

  # Disable automatic Qt wrapping to handle it manually
  dontWrapQtApps = true;

  # Add runtime dependencies to PATH for all wrapped binaries
  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        bash
        binutils
        coreutils
        desktop-file-utils
        erofs-utils
        fuse3
        fuse-overlayfs
        glib
        gnutar
        shared-mime-info
        linyaps-box
      ]
    }"
  ];

  # Note: ll-init must be statically linked and should not be wrapped
  postFixup = ''
    # Wrap all executables except ll-init
    find "$out" -type f -executable \
      \( -path "$out/bin/*" -o -path "$out/libexec/*" \) \
      ! -name "ll-init" \
      -print0 | while IFS= read -r -d "" f; do
      wrapQtApp "$f"
    done
  '';

  meta = {
    description = "Cross-distribution package manager with sandboxed apps and shared runtime";
    homepage = "https://linyaps.org.cn";
    downloadPage = "https://github.com/OpenAtom-Linyaps/linyaps";
    changelog = "https://github.com/OpenAtom-Linyaps/linyaps/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ll-cli";
    maintainers = with lib.maintainers; [
      wineee
      hhr2020
    ];
  };
})
