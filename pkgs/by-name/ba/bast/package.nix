{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  openssh,
}:

buildGoModule (finalAttrs: {
  pname = "bast";
  version = "0.6.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ellipse-software";
    repo = "bast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e5rXlHmSIDTH5sDJO+ivaPgreHobtbVYT2tY/N6Db7E=";
  };

  modRoot = "apps/bast";
  vendorHash = "sha256-PZVzmdRrElupXiaPGJrTK2uILGEa05R6OjEwdNWXOLw=";

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ openssh ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/bast" \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/bast --version | grep -F "bast v${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Fast terminal SSH host picker, key manager, and CLI";
    homepage = "https://github.com/ellipse-software/bast";
    changelog = "https://github.com/ellipse-software/bast/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "bast";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
