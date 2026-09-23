{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  yyjson,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsecretspec-resolver";
  version = "0.21.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "secretspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-12jIhLZhtyQwkt2vKHqjGOuKSwwevcxzp8Ii02RTMLY=";
  };

  cmakeDir = "../libsecretspec-resolver";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [ yyjson ];

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      version = "1.0.0";
      versionCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C client for SecretSpec's local resolver protocol";
    homepage = "https://secretspec.dev";
    changelog = "https://github.com/cachix/secretspec/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    pkgConfigModules = [ "secretspec-resolver" ];
  };
})
