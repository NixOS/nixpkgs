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
    rev = "97a0fcb790b43b9e5da8994f4671021fec036f19";
    hash = "sha256-YSN+Vo7Mzf55R2PodDgIwIzkt4BDUVdlet3Xtc21rDI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "criterion";
  version = "2.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vJ2b1bvwcdDgU23DrDfv73sg7nzrF7gF64gi6/4a1VQ=";
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

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    version =
      let
        tester = callPackage ./tests/001-version.nix { };
      in
      testers.testVersion {
        package = criterion;
        command = "${lib.getExe tester} --version";
        version = "v${finalAttrs.version}";
      };
  };

  meta = {
    description = "Cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    pkgConfigModules = [ "criterion" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thesola10
      Yumasi
      sigmanificient
    ];
    platforms = lib.platforms.unix;
  };
})
