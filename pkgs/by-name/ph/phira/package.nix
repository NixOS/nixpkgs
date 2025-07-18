{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  perl,
  makeWrapper,
  unzip,
  ffmpeg,
  alsa-lib,
  gtk3,
  clang,
  llvmPackages,
  libGL,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phira";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "TeamFlos";
    repo = "phira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4WIvLfKeh+quu7dHKMlUKt+NQnui2/txlFYZoU3voPA=";
  };

  nativeBuildInputs =
    [
      pkg-config
      perl
      makeWrapper
      unzip
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook # for crate coreaudio-sys
    ];

  buildInputs =
    [
      ffmpeg
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib # for crate alsa-sys
      gtk3 # for crate gtk-sys
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      clang # for crate coreaudio-sys
    ];

  patches = [
    ./ffmpeg.patch # use dynamically linked ffmpeg instead of expecting static lib
    ./stable-features.patch
    ./tracing.patch
    ./assets.patch
  ];

  cargoHash = "sha256-6mRb3M56G20fA+px1cZyrGpel0v54qoVAQK2ZgTzkmI=";

  # The developer put assets necessary for this test in gitignore, so it cannot run.
  checkFlags = [ "--skip test_parse_chart" ];

  postInstall =
    let
      # There are some assets that the developer put in gitignore but are required to launch the game,
      # so we grab them from the binary release.
      bin-src = fetchurl {
        url = "https://github.com/TeamFlos/phira/releases/download/v${finalAttrs.version}/Phira-windows-v${finalAttrs.version}.zip";
        hash = "sha256-iVwfuqU/jTPULjCtaPOcnYLNJZzEzFjvM0PqEGULLCw=";
      };
    in
    ''
      phira_root=$out/share/phira
      mkdir -p $phira_root
      unzip ${bin-src} "assets/*" -d $phira_root

      makeWrapper $out/bin/phira-main $out/bin/phira \
        ${lib.optionalString stdenv.hostPlatform.isLinux "--suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}"} \
        --run '
          export PHIRA_ROOT=''${PHIRA_ROOT-"$HOME/.local/share/phira"}
          if [[ ! -d "$PHIRA_ROOT/assets" ]]; then
            mkdir -p "$PHIRA_ROOT"
            cp -r "'$phira_root/assets'" "$PHIRA_ROOT"
          fi
        '
    '';

  meta = {
    description = "Rhythm game with custom charts and multiplayer";
    homepage = "https://github.com/TeamFlos/phira";
    # Source codes are GPL, but assets in bin-src are unfree. See https://github.com/TeamFlos/phira/issues/333
    license = with lib.licenses; [
      gpl3Only
      unfree
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    changelog = "https://github.com/TeamFlos/phira/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    mainProgram = "phira";
  };

})
