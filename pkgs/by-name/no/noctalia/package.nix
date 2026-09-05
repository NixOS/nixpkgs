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
  versionCheckHook,

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
  tzdata,
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
  # libqalculate 5.10.0 makes noctalia segfault, 5.12.0 works
  libqalculate' = libqalculate.overrideAttrs {
    version = "5.12.0";
    src = fetchFromGitHub {
      owner = "qalculate";
      repo = "libqalculate";
      tag = "v5.12.0";
      hash = "sha256-f9FzFcu2LtBM6B6apYo7uobeR5uZVb02FxX7Kng/rRI=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "noctalia";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-diS3b69rt/IqehH/8Tsd8/JEQmogVc1ml6FP+iTwBzg=";
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
    libqalculate'
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
    (lib.mesonEnable "tests" true)
    (lib.mesonEnable "jemalloc" (!stdenv.hostPlatform.isMusl))
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

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeCheckInputs = [
    tzdata
    gitMinimal
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

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
