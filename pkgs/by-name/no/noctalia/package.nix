{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # build
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  makeBinaryWrapper,
  autoAddDriverRunpath,
  installShellFiles,

  # libraries
  cairo,
  curl,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  jemalloc,
  libGL,
  libical,
  libjxl,
  libqalculate,
  librsvg,
  libsecret,
  libsndfile,
  libsodium,
  libwebp,
  libxkbcommon,
  libxml2,
  md4c,
  nlohmann_json,
  pam,
  pango,
  pipewire,
  polkit,
  sdbus-cpp_2,
  stb,
  systemdLibs,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wireplumber,

  # runtime
  gitMinimal,
}:

let
  # nixpkgs stb doesn't have stb_image_resize2.h which noctalia needs
  stb' = stb.overrideAttrs {
    version = "0-unstable-2025-10-26";
    src = fetchFromGitHub {
      owner = "nothings";
      repo = "stb";
      rev = "f1c79c02822848a9bed4315b12c8c8f3761e1296";
      hash = "sha256-BlyXJtAI7WqXCTT3ylww8zoG0hBxaojJnQDvdQOXJPE=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "noctalia";
  version = "5.0.0-beta.9";

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O07tHqxugZ/XE/90kx/UCZ0YCbHSI88v2ct2ezuCKi4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    makeBinaryWrapper
    autoAddDriverRunpath
    installShellFiles
  ];

  buildInputs = [
    cairo
    curl
    fontconfig
    freetype
    glib
    harfbuzz
    jemalloc
    libGL
    libical
    libjxl
    libqalculate
    librsvg
    libsecret
    libsndfile
    libsodium
    libwebp
    libxkbcommon
    libxml2
    md4c
    nlohmann_json
    pam
    pango
    pipewire
    polkit
    sdbus-cpp_2
    stb'
    systemdLibs
    tomlplusplus
    wayland
    wayland-protocols
    wireplumber
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" false)
  ];

  mesonBuildType = "release";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd noctalia \
      --bash <($out/bin/noctalia completions bash) \
      --fish <($out/bin/noctalia completions fish) \
      --zsh <($out/bin/noctalia completions zsh)
  '';

  # plugins are installed by cloning their repos
  postFixup = ''
    wrapProgram $out/bin/noctalia \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  # remove --version=unstable once 5.0.0 stable is released
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=unstable"
      "--version-regex"
      "v(5\\..*)"
    ];
  };

  meta = {
    description = "Sleek, customizable desktop shell crafted for Wayland";
    homepage = "https://noctalia.dev";
    changelog = "https://noctalia.dev/changelogs#v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20 # material_color_utilities is Apache 2.0
    ];
    mainProgram = "noctalia";
    maintainers = with lib.maintainers; [
      samiser
      pyrox0
    ];
    platforms = lib.platforms.linux;
  };
})
