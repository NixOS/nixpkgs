{
  lib,
  stdenv,
  fetchFromGitHub,

  gtest,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  python3,

  curl,
  libarchive,
  libossp_uuid,
  libpkgconf,
  libuuid,
  nlohmann_json,
  pkgsStatic,

  mesonlsp,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mesonlsp";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "mesonlsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6p+IufgUCZj21ylkZiYS8kVAdFgDZpOST5Lgb0mXDhQ=";
  };

  patches = [ ./disable-tests-that-require-network-access.patch ];

  nativeBuildInputs = [
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs =
    [
      curl
      libarchive
      libpkgconf
      nlohmann_json
    ]
    ++ lib.optionals stdenv.isDarwin [
      libossp_uuid
      pkgsStatic.fmt
    ]
    ++ lib.optionals stdenv.isLinux [ libuuid ];

  mesonFlags = [ "-Dbenchmarks=false" ];

  mesonCheckFlags = [ "--print-errorlogs" ];

  doCheck = true;

  postUnpack =
    let
      ada = fetchFromGitHub {
        owner = "ada-url";
        repo = "ada";
        rev = "v2.7.4";
        hash = "sha256-V5LwL03x7/a9Lvg1gPvgGipo7IICU7xyO2D3GqP6Lbw=";
      };

      muon = fetchFromGitHub {
        owner = "JCWasmx86";
        repo = "muon";
        rev = "62af239567ec3b086bae7f02d4aed3a545949155";
        hash = "sha256-k883mKwuP35f0WtwX8ybl9uYbvA3y6Vxtv2EJMpZDEs=";
      };

      sha256 = fetchFromGitHub {
        owner = "amosnier";
        repo = "sha-2";
        rev = "49265c656f9b370da660531db8cc6bf0a2e110a6";
        hash = "sha256-X9M/ZATYXUiE4oGorPBnsdaKnKaObarnMRh6QEfkBls=";
      };

      tomlplusplus = fetchFromGitHub {
        owner = "marzer";
        repo = "tomlplusplus";
        rev = "v3.4.0";
        hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
      };

      tree-sitter = fetchFromGitHub {
        owner = "tree-sitter";
        repo = "tree-sitter";
        rev = "v0.20.8";
        hash = "sha256-278zU5CLNOwphGBUa4cGwjBqRJ87dhHMzFirZB09gYM=";
      };

      tree-sitter-ini = fetchFromGitHub {
        owner = "JCWasmx86";
        repo = "tree-sitter-ini";
        rev = "20aa563306e9406ac55babb4474521060df90a30";
        hash = "sha256-1hHjtghBIf7lOPpupT1pUCZQCnzUi4Qt/yHSCdjMhCU=";
      };

      tree-sitter-meson = fetchFromGitHub {
        owner = "JCWasmx86";
        repo = "tree-sitter-meson";
        rev = "09665faff74548820c10d77dd8738cd76d488572";
        hash = "sha256-ice2NdK1/U3NylIQDnNCN41rK/G6uqFOX+OeNf3zm18=";
      };
    in
    ''
      (
        cd "$sourceRoot/subprojects"

        cp -R --no-preserve=mode,ownership ${ada} ada
        cp "packagefiles/ada/meson.build" ada

        cp -R --no-preserve=mode,ownership ${muon} muon

        cp -R --no-preserve=mode,ownership ${sha256} sha256
        cp "packagefiles/sha256/meson.build" sha256

        cp -R --no-preserve=mode,ownership ${tomlplusplus} tomlplusplus-3.4.0

        cp -R --no-preserve=mode,ownership ${tree-sitter} tree-sitter-0.20.8
        cp "packagefiles/tree-sitter-0.20.8/meson.build" tree-sitter-0.20.8

        cp -R --no-preserve=mode,ownership ${tree-sitter-ini} tree-sitter-ini
        cp "packagefiles/tree-sitter-ini/meson.build" tree-sitter-ini

        cp -R --no-preserve=mode,ownership ${tree-sitter-meson} tree-sitter-meson
        cp "packagefiles/tree-sitter-meson/meson.build" tree-sitter-meson
      )
    '';

  postPatch = ''
    substituteInPlace subprojects/muon/include/compilers.h \
      --replace-fail 'compiler_language new' 'compiler_language new_'

    patchShebangs src/libtypenamespace
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = mesonlsp;
      version = "v${finalAttrs.version}";
    };
  };

  meta = with lib; {
    description = "An unofficial, unendorsed language server for Meson written in C++";
    homepage = "https://github.com/JCWasmx86/mesonlsp";
    changelog = "https://github.com/JCWasmx86/mesonlsp/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    mainProgram = "mesonlsp";
    maintainers = with maintainers; [ paveloom ];
    platforms = platforms.unix;
  };
})
