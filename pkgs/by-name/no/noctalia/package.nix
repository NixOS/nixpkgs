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

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "noctalia";
  version = "5.0.0-beta.10";

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WijEuINvjcXMO/e/zMqwG1lyGiWNosnVt1QY+ko0Rw8=";
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
    stb
    systemdLibs
    tomlplusplus
    wayland
    wayland-protocols
    wireplumber
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" false)
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
