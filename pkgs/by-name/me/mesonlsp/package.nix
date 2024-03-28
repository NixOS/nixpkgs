{ lib
, stdenv
, fetchFromGitHub

, gtest
, makeWrapper
, meson
, ninja
, pkg-config
, python3

, curl
, libarchive
, libpkgconf
, libuuid
, nlohmann_json

, git
, mercurial
, subversion
}:

stdenv.mkDerivation rec {
  pname = "mesonlsp";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "mesonlsp";
    rev = "v${version}";
    hash = "sha256-xniEDRA+YPy9UcIWs8bXkpLsn9NCBEuhy8LrtP5yCTU=";
  };

  nativeBuildInputs = [
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    curl
    libarchive
    libpkgconf
    libuuid
    nlohmann_json
  ];

  nativeRuntimeInputs = lib.makeBinPath [
    git
    mercurial
    pkg-config
    subversion
  ];

  mesonFlags = [
    "-Dbenchmarks=false"
    "-Dtests=false"
  ];

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
        rev = "master";
        hash = "sha256-dsvxqSr+Hl5GKYj55MU0o4lHzgPbykuf6sQ/9h+bBPQ=";
      };

      sha256 = fetchFromGitHub {
        owner = "amosnier";
        repo = "sha-2";
        rev = "49265c656f9b370da660531db8cc6bf0a2e110a6";
        hash = "sha256-X9M/ZATYXUiE4oGorPBnsdaKnKaObarnMRh6QEfkBls=";
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
        rev = "master";
        hash = "sha256-1hHjtghBIf7lOPpupT1pUCZQCnzUi4Qt/yHSCdjMhCU=";
      };

      tree-sitter-meson = fetchFromGitHub {
        owner = "JCWasmx86";
        repo = "tree-sitter-meson";
        rev = "main";
        hash = "sha256-ice2NdK1/U3NylIQDnNCN41rK/G6uqFOX+OeNf3zm18=";
      };
    in
    ''(
    cd $sourceRoot/subprojects

    cp -R --no-preserve=mode,ownership ${ada} ada
    cp "packagefiles/ada/meson.build" ada

    cp -R --no-preserve=mode,ownership ${muon} muon

    cp -R --no-preserve=mode,ownership ${sha256} sha256
    cp "packagefiles/sha256/meson.build" sha256

    cp -R --no-preserve=mode,ownership ${tree-sitter} tree-sitter-0.20.8
    cp "packagefiles/tree-sitter-0.20.8/meson.build" tree-sitter-0.20.8

    cp -R --no-preserve=mode,ownership ${tree-sitter-ini} tree-sitter-ini
    cp "packagefiles/tree-sitter-ini/meson.build" tree-sitter-ini

    cp -R --no-preserve=mode,ownership ${tree-sitter-meson} tree-sitter-meson
    cp "packagefiles/tree-sitter-meson/meson.build" tree-sitter-meson
  )'';

  postPatch = ''
    patchShebangs src/libtypenamespace
  '';

  postFixup = ''
    wrapProgram $out/bin/mesonlsp --prefix PATH : "${nativeRuntimeInputs}"
  '';

  meta = with lib; {
    description = "An unofficial, unendorsed language server for meson written in C++";
    homepage = "https://github.com/JCWasmx86/mesonlsp";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "mesonlsp";
    maintainers = with maintainers; [ paveloom ];
  };
}
