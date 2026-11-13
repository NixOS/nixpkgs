{
  lib,
  buildGoModule,
  stdenvNoCC,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  pnpm_10,
  pnpmConfigHook,
  pnpmBuildHook,
  fetchPnpmDeps,
  nodejs,
}:
let
  pnpm = pnpm_10;
in
buildGoModule (finalAttrs: {
  pname = "git-bug";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "git-bug";
    repo = "git-bug";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lyQy6P929SQcmXZ1GI+5MtXoYD0b0xr69X9/y+1xCUs=";
  };

  webui = stdenvNoCC.mkDerivation {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-webui";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        ;
      inherit pnpm;

      sourceRoot = "${finalAttrs.src.name}/webui";
      fetcherVersion = 4;
      hash = "sha256-CQC+VWv9HwEiDQlS7t03k8zkqQLMGG7sX8qL3boFlhQ=";
    };

    nativeBuildInputs = [
      pnpm
      nodejs
      pnpmConfigHook
      pnpmBuildHook
    ];

    pnpmRoot = "webui";

    installPhase = ''
      runHook preInstall

      cp -r webui/ $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-TwAgpdlitF3O68wA+jyagifrLSRG7WCCZvJ1XJjP/pI=";

  overrideModAttrs = _: {
    # prevent `go mod vendor` from finding Go stuff in webui's node_modules
    preBuild = "";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  excludedPackages = [
    "./webui/node_modules"
    "cmd"
    "doc"
    "completion"
  ];

  tags = [
    "webui"
  ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    rm -rf webui
    cp -r ${finalAttrs.webui} webui
    CC="$CC_FOR_BUILD" LD="$CC_FOR_BUILD" GOOS= GOARCH= go generate
  '';

  checkFlags =
    let
      integrationTests = [
        "TestValidateUsername/existing_organisation"
        "TestValidateUsername/existing_organisation_with_bad_case"
        "TestValidateUsername/existing_username"
        "TestValidateUsername/existing_username_with_bad_case"
        "TestValidateUsername/non_existing_username"
        "TestValidateProject/public_project"
      ];
    in
    [
      "-skip=^${lib.concatStringsSep "$|^" integrationTests}$"
    ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installShellCompletion \
      --cmd git-bug \
      --bash misc/completion/bash/git-bug \
      --zsh misc/completion/zsh/git-bug \
      --fish misc/completion/fish/git-bug

    installManPage doc/man/*
  '';

  meta = {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/git-bug/git-bug";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      royneary
      DeeUnderscore
    ];
    mainProgram = "git-bug";
  };
})
