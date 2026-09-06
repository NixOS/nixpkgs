{
  addDriverRunpath,
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  imagemagick,
  patchelf,
  pkg-config,

  alsa-lib,
  dbus,
  fontconfig,
  libGL,
  libseccomp,
  libxcb,
  libxkbcommon,
  openssl,
  vulkan-loader,
  wayland,

  copyDesktopItems,
  makeDesktopItem,

  apple-sdk_15,

  msaClientID ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pandora-launcher-unwrapped";
  version = "5.5.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Moulberry";
    repo = "PandoraLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mn+ZYSIJajc6gzYSdZUvDrfDouXJWlbSeO7nfjKN4sY=";
  };

  # Currently the client id is hardcoded and must be patched like this.
  postPatch = lib.optionalString (msaClientID != null) ''
    substituteInPlace crates/auth/src/constants.rs \
      --replace-fail \
      'pub const CLIENT_ID: &str = "e5226706-5096-431d-9516-ae48fe263401";' \
      'pub const CLIENT_ID: &str = "${msaClientID}";'
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    imagemagick
    patchelf
  ];

  buildInputs = [
    fontconfig
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    libseccomp
    libxcb
    libxkbcommon
    wayland
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  doCheck = false; # there aren't any tests

  env.OPENSSL_NO_VENDOR = true;

  dontUpdateAutotoolsGnuConfigScripts = true; # will modify vendor dir, which cargo doesn't allow
  cargoVendorDir = "vendor"; # everything is vendored in-tree
  dontCargoSetupPostUnpack = true;

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "com.moulberry.pandoralauncher";
      desktopName = "Pandora Launcher";
      genericName = "Unofficial Minecraft Launcher";
      exec = "pandora_launcher";
      icon = "pandora_launcher";
    })
  ];

  infoPlist = lib.generators.toPlist { escape = true; } {
    CFBundleDevelopmentRegion = "en";
    CFBundleDisplayName = "Pandora Launcher";
    CFBundleExecutable = "pandora_launcher";
    CFBundleIconFile = "mac.icns";
    CFBundleIdentifier = "com.moulberry.pandoralauncher";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = "Pandora Launcher";
    CFBundlePackageType = "APPL";
    CFBundleShortVersionString = finalAttrs.version;
    CFBundleVersion = finalAttrs.version;
    NSHighResolutionCapable = true;
    NSMicrophoneUsageDescription = "A Minecraft mod wants to access your microphone.";
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/PandoraLauncher.app/Contents/{MacOS,Resources}
      cp package/mac.icns $out/Applications/PandoraLauncher.app/Contents/Resources/
      printf '%s' ${lib.escapeShellArg finalAttrs.infoPlist} > $out/Applications/PandoraLauncher.app/Contents/Info.plist
      ln -s $out/bin/pandora_launcher $out/Applications/PandoraLauncher.app/Contents/MacOS/pandora_launcher
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      for size in 16 24 32 48 64 128 256; do
        geometry="$size"x"$size"
        mkdir -p "$out/share/icons/hicolor/$geometry/apps"
        magick package/windows.svg -resize "$geometry" \
          "$out/share/icons/hicolor/$geometry/apps/pandora_launcher.png"
      done
    '';

  doInstallCheck = true;

  installCheckPhase =
    let
      expectedOutput = builtins.toFile "pandora-launcher-help-expected" ''
        Usage: pandora_launcher [OPTIONS]

        Options:
              --run-instance <RUN_INSTANCE>  Instance to launch, instead of opening the launcher
          -h, --help                         Print help
      '';
    in
    ''
      runHook preInstallCheck

      diff <($out/bin/pandora_launcher --help) ${expectedOutput}

      runHook postInstallCheck
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath "${addDriverRunpath.driverLink}/lib:${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }" $out/bin/pandora_launcher
  '';

  meta = {
    description = "Minecraft launcher that balances ease-of-use with powerful instance management features";
    homepage = "https://github.com/Moulberry/PandoraLauncher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dtomvan
      eveeifyeve
    ];
    mainProgram = "pandora_launcher";
  };
})
