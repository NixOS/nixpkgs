{
  lib,
  stdenv,
  rustPlatform,
  callPackage,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  openssl,
  pcsclite,
  udev,
  webkitgtk_4_1,
  nix-update-script,
  runCommand,
  jq,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    libfido2-token2 = callPackage ./libfido2.nix {
      inherit (finalAttrs) src;
    };
    token2-piv-tool = callPackage ./token2-piv-tool.nix {
      inherit (finalAttrs) src version;
    };
  in
  {
    pname = "fido2-manage";
    version = "0.2.2";

    src = fetchFromGitHub {
      owner = "token2";
      repo = "fido2-manage";
      tag = finalAttrs.version;
      hash = "sha256-TGNPXRoxP0J2WiaiVJmNzE1xtbbwNQq3NapoW+Iw8yE=";
    };

    cargoRoot = "token2-piv-gui/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;
    cargoHash = "sha256-X7X23j4HjeorgcmbwJ1ShWvdWZ89DbLuY84q5f9NIAk=";

    nativeBuildInputs = [
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
      copyDesktopItems
    ];

    buildInputs = [
      libfido2-token2
      token2-piv-tool
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pcsclite
      udev
      webkitgtk_4_1
    ];

    env = {
      FIDO2_LIB_DIR = "${lib.getLib libfido2-token2}/lib";
      T2PIV_LIB_DIR = "${token2-piv-tool}/lib";
    };

    # select Tauri's production mode for the checked-in frontend
    buildFeatures = [ "tauri/custom-protocol" ];

    postPatch = ''
      # Shared libraries are supplied by Nix, not Tauri bundle resources.
      substituteInPlace token2-piv-gui/src-tauri/tauri.conf.json \
        --replace-fail '"libs/*"' ""
    '';

    postInstall = ''
      for tool in token cred assert; do
        ln -s ${libfido2-token2}/bin/fido2-$tool $out/bin/token2-fido2-$tool
      done
      ln -s ${token2-piv-tool}/bin/token2-piv-tool $out/bin/token2-piv-tool
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 token2-piv-gui/src-tauri/icons/icon.png \
        $out/share/icons/hicolor/256x256/apps/token2-key-manager.png
    '';

    # Only the GUI needs the GTK environment, not the CLI tools
    dontWrapGApps = true;
    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/token2-key-manager "''${gappsWrapperArgs[@]}"
    '';

    desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
      (makeDesktopItem {
        name = "token2-key-manager";
        desktopName = "Token2 Key Manager";
        comment = finalAttrs.meta.description;
        exec = "token2-key-manager";
        icon = "token2-key-manager";
        categories = [
          "Utility"
          "Security"
        ];
      })
    ];

    passthru = {
      updateScript = nix-update-script { };
      tests.cli =
        runCommand "fido2-manage-cli-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              jq
            ];
          }
          ''
            # The build sandbox has no security keys or PC/SC daemon
            # The only response we can get is "no devices connected"
            fido2-manage -list -json | jq -e '. == []'
            token2-fido2-token -L
            token2-piv-tool --version
            touch $out
          '';
    };

    meta = {
      description = "Manage FIDO2 security keys, PIV certificates and OTP accounts";
      homepage = "https://github.com/token2/fido2-manage";
      changelog = "https://github.com/token2/fido2-manage/releases/tag/${finalAttrs.version}";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      license = lib.licenses.bsd2;
      mainProgram = "fido2-manage";
      maintainers = with lib.maintainers; [
        Srylax
        Cosipa
      ];
    };
  }
)
