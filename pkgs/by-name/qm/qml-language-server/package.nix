{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "qml-language-server";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cushycush";
    repo = "qml-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1VWTqzVWCJRW2X2xSivdGKul64OEwIVurNqBT3LloqQ=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-J+0kFTKgluf+mabJepW+MGXUdHqYLFaUVAZEWcyHmyk=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # Regenerate the built-in grammars bundle
  preBuild = ''
    make gen-grammar
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go-based Language Server for QML that provides intelligent code editing features";
    homepage = "https://github.com/cushycush/qml-language-server";
    changelog = "https://github.com/cushycush/qml-language-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "qml-language-server";
  };
})
