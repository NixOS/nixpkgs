{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  python3Packages,
  gitMinimal,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boxfort";
  version = "0.1.9";

  __structuredAttrs = true;
  __strictDeps = true;

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "BoxFort";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A79IDBDo/pX03aEaXZbmNW+0k/TTtpT1e6HZsLz8I+E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gitMinimal
  ];

  preConfigure = ''
    patchShebangs ci/isdir.py
  '';

  nativeCheckInputs = with python3Packages; [ cram ];

  doCheck = true;

  outputs = [
    "dev"
    "out"
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = lib.licenses.mit;
    pkgConfigModules = [ "boxfort" ];
    maintainers = with lib.maintainers; [
      sigmanificient
      thesola10
      Yumasi
    ];
    platforms = lib.platforms.unix;
  };
})
