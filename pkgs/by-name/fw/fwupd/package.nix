# Updating? Keep $out/etc synchronized with passthru keys

{
  lib,
  stdenv,

  # runPythonCommand
  runCommand,
  python3,

  # test-firmware
  fetchFromGitHub,
  unstableGitUpdater,

  # fwupd
  pkg-config,
  pkgsBuildBuild,

  # propagatedBuildInputs
  json-glib,

  # nativeBuildInputs
  ensureNewerSourcesForZipFilesHook,
  gettext,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  protobuf,
  protobufc,
  shared-mime-info,
  vala,
  wrapGAppsNoGuiHook,
  writableTmpDirAsHomeHook,
  mesonEmulatorHook,

  # buildInputs
  bash-completion,
  curl,
  elfutils,
  fwupd-efi,
  gnutls,
  gusb,
  libarchive,
  libcbor,
  libdrm,
  libgudev,
  libjcat,
  libmbim,
  libmnl,
  libqmi,
  libuuid,
  libxmlb,
  libxml2,
  modemmanager,
  pango,
  polkit,
  readline,
  sqlite,
  tpm2-tss,
  valgrind,
  xz, # for liblzma
  flashrom,

  # mesonFlags
  hwdata,

  # env
  makeFontsConf,
  freefont_ttf,

  # preCheck
  libredirect,

  # preFixup
  bubblewrap,
  efibootmgr,
  tpm2-tools,

  # passthru
  nixosTests,
  nix-update-script,

  enableFlashrom ? false,
  enablePassim ? false,
}:

let
  isx86 = stdenv.hostPlatform.isx86;

  # Experimental
  haveFlashrom = isx86 && enableFlashrom;

  runPythonCommand =
    name: buildCommandPython:

    runCommand name
      {
        nativeBuildInputs = [ python3 ];
        inherit buildCommandPython;
      }
      ''
        exec python3 -c "$buildCommandPython"
      '';

  test-firmware =
    let
      version = "0-unstable-2022-04-02";
      src = fetchFromGitHub {
        name = "fwupd-test-firmware-${version}";
        owner = "fwupd";
        repo = "fwupd-test-firmware";
        rev = "39954e434d63e20e85870dd1074818f48a0c08b7";
        hash = "sha256-d4qG3fKyxkfN91AplRYqARFz+aRr+R37BpE450bPxi0=";
        passthru = {
          inherit src version; # For update script
          updateScript = unstableGitUpdater {
            url = "${test-firmware.meta.homepage}.git";
          };
        };
      };
    in
    src
    // {
      meta = src.meta // {
        # For update script
        position =
          let
            pos = builtins.unsafeGetAttrPos "updateScript" test-firmware;
          in
          pos.file + ":" + toString pos.line;
      };
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fwupd";
  version = "2.0.16";

  # libfwupd goes to lib
  # daemon, plug-ins and libfwupdplugin go to out
  # CLI programs go to out
  outputs = [
    "out"
    "lib"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = "fwupd";
    tag = finalAttrs.version;
    hash = "sha256-fsjW3Idaqg4pNGaRP0bm2R94FcW2MVfPQwPFWrN+Qy8=";
  };

  patches = [
    # Install plug-ins and libfwupdplugin to $out output,
    # they are not really part of the library.
    ./install-fwupdplugin-to-out.patch

    # Installed tests are installed to different output
    # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle.
    ./installed-tests-path.patch

    # Since /etc is the domain of NixOS, not Nix,
    # we cannot install files there.
    # Let’s install the files to $prefix/etc
    # while still reading them from /etc.
    # NixOS module for fwupd will take take care of copying the files appropriately.
    ./add-option-for-installation-sysconfdir.patch

    # EFI capsule is located in fwupd-efi now.
    ./efi-app-path.patch
  ];

  postPatch = ''
    patchShebangs \
      generate-build/generate-version-script.py \
      generate-build/generate-man.py \
      po/test-deps \
      plugins/uefi-capsule/tests/grub2-mkconfig \
      plugins/uefi-capsule/tests/grub2-reboot
  ''
  # in nixos test tries to chmod 0777 $out/share/installed-tests/fwupd/tests/redfish.conf
  + ''
    substituteInPlace plugins/redfish/meson.build \
      --replace-fail "get_option('tests')" "false"
  '';

  strictDeps = true;

  depsBuildBuild = [
    pkg-config # for finding build-time dependencies
    (pkgsBuildBuild.callPackage ./build-time-python.nix { })
  ];

  propagatedBuildInputs = [
    json-glib
  ];

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook # required for firmware zipping
    gettext
    gi-docgen
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    protobuf # for protoc
    protobufc # for protoc-gen-c
    shared-mime-info
    vala
    wrapGAppsNoGuiHook

    # jcat-tool at buildtime requires a home directory
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    bash-completion
    curl
    elfutils
    fwupd-efi
    gnutls
    gusb
    libarchive
    libcbor
    libdrm
    libgudev
    libjcat
    libmbim
    libmnl
    libqmi
    libuuid
    libxmlb
    modemmanager
    pango
    polkit
    protobufc
    readline
    sqlite
    tpm2-tss
    valgrind
    xz # for liblzma
  ]
  ++ lib.optionals haveFlashrom [
    flashrom
  ];

  mesonFlags = [
    (lib.mesonEnable "docs" true)
    # We are building the official releases.
    (lib.mesonEnable "supported_build" true)
    (lib.mesonOption "systemd_root_prefix" "${placeholder "out"}")
    (lib.mesonOption "installed_test_prefix" "${placeholder "installedTests"}")
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    (lib.mesonOption "sysconfdir_install" "${placeholder "out"}/etc")
    (lib.mesonOption "efi_os_dir" "nixos")
    (lib.mesonEnable "plugin_modem_manager" true)
    (lib.mesonBool "vendor_metadata" true)
    (lib.mesonBool "plugin_uefi_capsule_splash" false)
    # TODO: what should this be?
    (lib.mesonOption "vendor_ids_dir" "${hwdata}/share/hwdata")
    (lib.mesonEnable "umockdev_tests" false)
    # We do not want to place the daemon into lib (cyclic reference)
    "--libexecdir=${placeholder "out"}/libexec"
  ]
  ++ lib.optionals (!enablePassim) [
    (lib.mesonEnable "passim" false)
  ]
  ++ lib.optionals (!haveFlashrom) [
    (lib.mesonEnable "plugin_flashrom" false)
  ];

  # TODO: wrapGAppsHook3 wraps efi capsule even though it is not ELF
  dontWrapGApps = true;

  doCheck = true;

  # Environment variables
  env = {
    # Fontconfig error: Cannot load default config file
    FONTCONFIG_FILE =
      let
        fontsConf = makeFontsConf {
          fontDirectories = [ freefont_ttf ];
        };
      in
      fontsConf;

    # error: “PolicyKit files are missing”
    # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
    PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";
  };

  nativeCheckInputs = [
    polkit
    libredirect.hook
  ];

  preCheck = ''
    addToSearchPath XDG_DATA_DIRS "${shared-mime-info}/share"

    echo "12345678901234567890123456789012" > machine-id
    export NIX_REDIRECTS=/etc/machine-id=$(realpath machine-id) \
  '';

  postInstall = ''
    # These files have weird licenses so they are shipped separately.
    cp --recursive --dereference "${test-firmware}/installed-tests/tests" "$installedTests/libexec/installed-tests/fwupd"
  '';

  preFixup =
    let
      binPath = [
        bubblewrap
        efibootmgr
        tpm2-tools
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
        # See programs reached with fu_common_find_program_in_path in source
        --prefix PATH : "${lib.makeBinPath binPath}"
      )
    '';

  postFixup = ''
    # Since we had to disable wrapGAppsHook, we need to wrap the executables manually.
    find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "$file" != *.efi ]]; then
        echo "Wrapping program $file"
        wrapGApp "$file"
      fi
    done

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
    moveToOutput "etc/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
    filesInstalledToEtc = [
      "fwupd/fwupd.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "fwupd/remotes.d/vendor-directory.conf"
      "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
      "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd-metadata/LVFS-CA.pem"
      "grub.d/35_fwupd"
    ];

    # For updating.
    inherit test-firmware;

    # For downstream consumers that need the fwupd-efi this was built with.
    inherit fwupd-efi;

    tests =
      let
        listToPy = list: "[${lib.concatMapStringsSep ", " (f: "'${f}'") list}]";
      in
      {
        installedTests = nixosTests.installed-tests.fwupd;

        passthruMatches = runPythonCommand "fwupd-test-passthru-matches" ''
          import itertools
          import configparser
          import os
          import pathlib

          etc = '${finalAttrs.finalPackage}/etc'
          package_etc = set(itertools.chain.from_iterable([[os.path.relpath(os.path.join(prefix, file), etc) for file in files] for (prefix, dirs, files) in os.walk(etc)]))
          passthru_etc = set(${listToPy finalAttrs.passthru.filesInstalledToEtc})
          assert len(package_etc - passthru_etc) == 0, f'fwupd package contains the following paths in /etc that are not listed in passthru.filesInstalledToEtc: {package_etc - passthru_etc}'
          assert len(passthru_etc - package_etc) == 0, f'fwupd package lists the following paths in passthru.filesInstalledToEtc that are not contained in /etc: {passthru_etc - package_etc}'

          pathlib.Path(os.getenv('out')).touch()
        '';
      };
  };

  meta = {
    homepage = "https://fwupd.org/";
    changelog = "https://github.com/fwupd/fwupd/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      rvdp
      johnazoidberg
    ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
