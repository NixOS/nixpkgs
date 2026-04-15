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
  version = "5.0.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Moulberry";
    repo = "PandoraLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AN7q/efnsypwv6w4XP1vcQfncGljjp2DQreR9i3VVR4=";
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
    copyDesktopItems

    imagemagick
    patchelf
    pkg-config
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

  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [ "gpui/runtime_shaders" ];

  doCheck = false; # there aren't any tests

  env.OPENSSL_NO_VENDOR = true;

  dontUpdateAutotoolsGnuConfigScripts = true; # will modify vendor dir, which cargo doesn't allow
  cargoVendorDir = "vendor"; # everything is vendored in-tree
  dontCargoSetupPostUnpack = true;

  desktopItems = lib.singleton (makeDesktopItem {
    name = "com.moulberry.pandoralauncher";
    desktopName = "Pandora Launcher";
    genericName = "Unofficial Minecraft Launcher";
    exec = "pandora_launcher";
    icon = "pandora_launcher";
  });

  postInstall = ''
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
