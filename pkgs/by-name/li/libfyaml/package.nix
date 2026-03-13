{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfyaml";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = "libfyaml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DgXNnmFGZ6a7ELK1SsxPkc5mcVO9w/4uMkhjnqj3CUI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  configureFlags = [ "--disable-network" ];

  doCheck = true;

  preCheck = ''
    patchShebangs test
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    homepage = "https://github.com/pantoniou/libfyaml";
    changelog = "https://github.com/pantoniou/libfyaml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
    pkgConfigModules = [ "libfyaml" ];
    platforms = lib.platforms.all;
  };
})
