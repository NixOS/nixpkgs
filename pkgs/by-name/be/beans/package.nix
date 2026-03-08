{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beans";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hmans";
    repo = "beans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3SgTqR5DGAb5r+VU3YknoWATqglq8G7QV3kTVUSL9u4=";
  };

  vendorHash = "sha256-TprfPZ/clb7PLMAkxF0y78bCef4XarhgHlIhIPn1nQA=";

  ldflags = [
    "-s"
    "-X github.com/hmans/beans/cmd.version=${finalAttrs.version}"
    "-X github.com/hmans/beans/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/hmans/beans/cmd.date=unknown"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Issue tracker for you, your team, and your coding agents";
    homepage = "https://github.com/hmans/beans";
    changelog = "https://github.com/hmans/beans/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sleroq ];
    mainProgram = "beans";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
