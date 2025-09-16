{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  ninja,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biplanes-revival";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "regular-dev";
    repo = "biplanes-revival";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rdPcI4j84fVKNwv2OQ9gwC0X2CHlObYfSYkCMlcm4sM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  strictDeps = true;

  postInstall = ''
    id="org.regular_dev.biplanes_revival"
    install -Dm644 $src/flatpak-data/$id.desktop -t $out/share/applications
    install -Dm644 $src/flatpak-data/$id.metainfo.xml -t $out/share/metainfo
    install -Dm644 $src/flatpak-data/$id.svg -t $out/share/icons/hicolor/scalable/apps

    # Move assets directory into the preferred location.
    mkdir -p $out/share/biplanes-revival
    mv $out/bin/assets $out/share/biplanes-revival

    # Remove TimeUtils headers.
    rm -rf $out/include
  '';

  postFixup = ''
    # Set assets root, the default is the current working directory.
    # The game automatically appends "/assets" to the variable.
    wrapProgram $out/bin/BiplanesRevival \
      --set BIPLANES_ASSETS_ROOT "$out/share/biplanes-revival";
  '';

  env.NIX_CFLAGS_COMPILE = "-I ../deps/TimeUtils/include";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "BiplanesRevival";
    description = "Old cellphone arcade recreated for PC";
    homepage = "https://regular-dev.org/biplanes-revival";
    changelog = "https://github.com/regular-dev/biplanes-revival/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };
})
