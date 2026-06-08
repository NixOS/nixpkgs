{
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs,
  npmHooks,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "bindery";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "vavallee";
    repo = "bindery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xwm1U5sz4qY0M57TPkI3pmVxmPdefBENB4ucgO6djtE=";
  };
  vendorHash = "sha256-G97Q6yOlGF+LSadmkm3afrHedUSZUro6VxOd8RUD7vw=";
  subPackages = "cmd/bindery";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/web";
    hash = "sha256-EHgKGEbiZ6Yousddczmsn9cAhBM8tLq2VgmqAL5y15M=";
  };

  npmRoot = "web";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  preBuild = ''
    npm --prefix="$npmRoot" run build
    cp -r "$npmRoot"/dist/* internal/webui/dist/
    CC="$CC_FOR_BUILD" LD="$CC_FOR_BUILD" GOOS= GOARCH= go generate ./...
  '';

  env.CGO_ENABLED = 0;

  checkFlags =
    let
      skippedTests = [
        "TestIndexerCRUD"
        "TestIndexerCreate_DuplicateURL"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Automated book download manager for Usenet";
    homepage = "https://github.com/vavallee/bindery";
    changelog = "https://github.com/vavallee/bindery/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flyingpeakock ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "bindery";
  };
})
