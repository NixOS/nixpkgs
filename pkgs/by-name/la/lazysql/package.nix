{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libx11,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "lazysql";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s22JHYS8H1KQb54mExJlh1yrADcgLohf5/xeevnrxAo=";
  };

  vendorHash = "sha256-dhQRURBA8WzA0uweIWcS/x9edClGatbMCcOn55xlF2w=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    changelog = "https://github.com/jorgerojas26/lazysql/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazysql";
  };
})
