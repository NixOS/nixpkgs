{
  lib,
  stdenv,
  fetchFromGitHub,

  gtest,
  meson,
  ninja,
  pkg-config,
  python3,

  curl,
  libarchive,
  libossp_uuid,
  libpkgconf,
  tomlplusplus,
  libuuid,
  nlohmann_json,
  tree-sitter,
  pkgsStatic,

  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mesonlsp";
  version = "5.0.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "mesonlsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j8J/IREXYwH6KP9KlUTAfLpNN3n7yJSxoh8fqcvQ2P8=";
  };

  mesonSubprojects = {
    ada = fetchFromGitHub {
      owner = "ada-url";
      repo = "ada";
      rev = "v2.7.4";
      hash = "sha256-V5LwL03x7/a9Lvg1gPvgGipo7IICU7xyO2D3GqP6Lbw=";
    };

    muon = fetchFromGitHub {
      owner = "JCWasmx86";
      repo = "muon";
      rev = "cea0b8e6c2874d1f2ce4057a17bd37090f619b6b";
      hash = "sha256-MM47mdMKpQBykWeL1aSufH/BYfy+uAWVJLWWMhXolsE=";
    };

    sha256 = fetchFromGitHub {
      owner = "amosnier";
      repo = "sha-2";
      rev = "49265c656f9b370da660531db8cc6bf0a2e110a6";
      hash = "sha256-X9M/ZATYXUiE4oGorPBnsdaKnKaObarnMRh6QEfkBls=";
    };

    tree-sitter-ini = fetchFromGitHub {
      owner = "JCWasmx86";
      repo = "tree-sitter-ini";
      rev = "848b6269f7039739aebd169fbd3d5e6e34bef661";
      hash = "sha256-Lmlp20gxwfkWMbk81pBwfS7nc3ZBcMfjPzFB2ozhhLk=";
    };

    tree-sitter-meson = fetchFromGitHub {
      owner = "JCWasmx86";
      repo = "tree-sitter-meson";
      rev = "09665faff74548820c10d77dd8738cd76d488572";
      hash = "sha256-ice2NdK1/U3NylIQDnNCN41rK/G6uqFOX+OeNf3zm18=";
    };
  };

  patches = [
    # TODO: use mesonCheckFlag once nixpkgs updates to meson 1.12.0
    ./disable-tests-that-require-network-access.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  buildInputs = [
    curl
    gtest
    libarchive
    libpkgconf
    nlohmann_json
    tomlplusplus
    tree-sitter
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libossp_uuid
    pkgsStatic.fmt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libuuid ];

  mesonFlags = with lib.strings; [
    (mesonBool "use_own_tree_sitter" false) # one less vendored dependency
    (mesonBool "benchmarks" false)
    # meson flags from $src/mesonlsp.spec
    # couldn't get it to find tracy anyway
    (mesonEnable "muon:tracy" false)
    (mesonEnable "muon:meson-docs" false)
    (mesonEnable "muon:meson-tests" false)
    (mesonEnable "muon:man-pages" false)
    (mesonEnable "muon:website" false)
    (mesonEnable "muon:native_backtrace" false)
  ];

  doCheck = true;
  doInstallCheck = true;

  postUnpack = ''
    (
      cd "$sourceRoot"

      ${lib.concatMapAttrsStringSep "\n" (name: value: ''
        cp -R --no-preserve=mode,ownership ${value} subprojects/${name}
      '') finalAttrs.mesonSubprojects}

      meson subprojects packagefiles --apply
    )
  '';

  postPatch = ''
    patchShebangs src/libtypenamespace
  '';

  mesonCheckFlags = [
    "--print-errorlogs"
    # requires internet
    # "--exclude=utilstest" (meson 1.12.0)
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Unofficial, unendorsed language server for Meson written in C++";
    homepage = "https://github.com/JCWasmx86/mesonlsp";
    changelog = "https://github.com/JCWasmx86/mesonlsp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "mesonlsp";
    maintainers = [ lib.maintainers.quantenzitrone ];
    platforms = lib.platforms.unix;
  };
})
