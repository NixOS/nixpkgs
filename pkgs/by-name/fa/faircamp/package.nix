{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  makeBinaryWrapper,
  pkg-config,
  dbus,
  glib,
  libglvnd,
  libopus,
  libxkbcommon,
  wayland,
  ffmpeg,
  fontconfig,
  callPackage,
  testers,
  faircamp,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "faircamp";
  version = "2.0.2";

  src = fetchFromCodeberg {
    owner = "simonrepp";
    repo = "faircamp";
    rev = finalAttrs.version;
    hash = "sha256-2GlsI9lkoCobtkTnnmM6IGU3d44Ci29hn8tFVhkhDMA=";
  };

  cargoHash = "sha256-H1bb4ETd5TqGAGPYN2GLp4P8ykcIO+cqzD30E2pdZGA=";

  postPatch = ''
    # Link against the maintained system Opus instead of the bundled copy.
    substituteInPlace $cargoDepsCopy/*/opusic-sys-*/Cargo.toml \
      --replace-fail 'default = ["bundled"]' 'default = []'
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    dbus
    glib
    libglvnd
    libopus
    libxkbcommon
    wayland
    zstd
  ];

  # Force linking to libEGL, which is always dlopen()ed, to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend, and to libdbus-1, which is dlopen()ed by rfd to open file dialogs.
  env.NIX_LDFLAGS = toString [
    "--push-state"
    "--no-as-needed"
    "-lEGL"
    "-ldbus-1"
    "-lwayland-client"
    "-lxkbcommon"
    "--pop-state"
  ];

  postInstall = ''
    for program in "$out/bin/faircamp" "$out/bin/faircamp-cli"; do
      wrapProgram "$program" \
        --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
    done
  '';

  passthru.tests = {
    wav = callPackage ./test-wav.nix { };
    version = testers.testVersion { package = faircamp; };
  };

  meta = {
    description = "Static site generator for audio producers";
    mainProgram = "faircamp";
    longDescription = ''
      Faircamp takes a directory on your disk - your Catalog - and from it
      produces a fancy-looking (and technically simple and completely static)
      website, which presents your music in a way similar to how popular
      commercial service bandcamp does it.

      You can upload the files faircamp generates to any webspace - no database
      and no programming language support (PHP or such) is required. If your
      webspace supports SSH access, faircamp can be configured to upload your
      website for you automatically, otherwise you can use FTP or whichever
      means you prefer to do that manually.
    '';
    homepage = "https://faircamp.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
