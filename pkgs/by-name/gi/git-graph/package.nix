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
  version = "0.8.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "git-bahn";
    repo = "git-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tBv47iXYQicwAuAeKshuW2qDwJrz9NBm0KVqrQc8mVg=";
  };

  cargoHash = "sha256-+MAQ3TyfLrpbrgPIDT5KWrbwsfL49QnvIiVA0nsRMNU=";

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
