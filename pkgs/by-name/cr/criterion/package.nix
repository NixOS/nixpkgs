{
  lib,
  stdenv,
  fetchFromGitHub,
  boxfort,
  meson,
  pkg-config,
  gettext,
  cmake,
  ninja,
  protobuf,
  gitMinimal,
  libffi,
  libgit2,
  dyncall,
  nanomsg,
  nanopbMalloc,
  python3Packages,
  testers,
  criterion,
  callPackage,
}:

let
  # follow revisions defined in .wrap files
  debugbreak = fetchFromGitHub {
    owner = "MrAnno";
    repo = "debugbreak";
    rev = "83bf7e933311b88613cbaadeced9c2e2c811054a";
    hash = "sha256-OPrPGBUZN73Nl5NMEf/nME843yTolt913yjut3rAos0=";
  };

  klib = fetchFromGitHub {
    owner = "attractivechaos";
    repo = "klib";
    rev = "cdb7e9236dc47abf8da7ebd702cc6f7f21f0c502";
    hash = "sha256-+GaI5nXz4jYI0rO17xDhNtFpLlGL2WzeSVLMfB6Cl6E=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "criterion";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-X4m/uCyanS7HLtf6GyK4XuaT5i+HQt1PZC7gd813IVQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    protobuf
    gitMinimal
  ];

  buildInputs = [
    (lib.getDev boxfort)
    dyncall
    gettext
    nanomsg
    nanopbMalloc
    libgit2
    libffi
  ];

  nativeCheckInputs = with python3Packages; [ cram ];

  doCheck = true;

  prePatch = ''
    cp -r ${debugbreak} subprojects/debugbreak
    cp -r ${klib} subprojects/klib

    for dep in "debugbreak" "klib"; do
      local meson="$dep/meson.build"

      chmod +w subprojects/$dep
      cp subprojects/packagefiles/$meson subprojects/$meson
    done
  '';

  postPatch = ''
    patchShebangs ci/isdir.py src/protocol/gen-pb.py
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests.version =
    let
      tester = callPackage ./tests/001-version.nix { };
    in
    testers.testVersion {
      package = criterion;
      command = "${lib.getExe tester} --version";
      version = "v${finalAttrs.version}";
    };

  meta = {
    description = "Cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thesola10
      Yumasi
      sigmanificient
    ];
    platforms = lib.platforms.unix;
  };
})
