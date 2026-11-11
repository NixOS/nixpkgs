{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  libgit2,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-graph";
  version = "0.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "git-bahn";
    repo = "git-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NtgD2NxV1JREzBKCcytawuhKvgQz+vP2ginduzEr3jw=";
  };

  cargoHash = "sha256-ZQ3zJYtTCOLpFV/rQ08NtTfwUNQ0MEAOdK7j9c3uMgM=";

  env.LIBGIT2_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/git-bahn/git-graph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-graph";
  };
})
