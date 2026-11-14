{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  scdoc,
  ftxui,
  curl,
  sqlite,
  nlohmann_json,
  tomlplusplus,
  luajit,
  sol2,
  tree-sitter,
  chafa,
  spdlog,
  doctest,
  stb,
  libsecret,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plume";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "plume";
    rev = "bdf4c095fab7aa7c8972ebe5f6f8248e9e5e5f61";
    hash = "sha256-gRDxeZMS8uam7D3RPt/CagStZ4E93JYCSTd5bLpgBjg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    ftxui
    curl
    sqlite
    nlohmann_json
    tomlplusplus
    luajit
    sol2
    tree-sitter
    chafa
    spdlog
    doctest
    stb
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libsecret ];

  cmakeFlags = [
    (lib.cmakeFeature "PLUME_VERSION" finalAttrs.version)
    # -Werror is fragile across compiler versions; upstream keeps it on for dev.
    (lib.cmakeBool "PLUME_WERROR" false)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Terminal client for language models with a weaveable conversation tree";
    homepage = "https://github.com/vmfunc/plume";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "plume";
    platforms = lib.platforms.unix;
  };
})
