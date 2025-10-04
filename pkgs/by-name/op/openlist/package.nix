{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  versionCheckHook,
  fuse,
}:

buildGoModule (finalAttrs: {
  pname = "openlist";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CNnDPA/zByhR6GOmzxOZRc8F/QqGIxTGSIKXOCwlwwg=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  frontend = callPackage ./frontend.nix { };

  proxyVendor = true;
  vendorHash = "sha256-MHqQ/2FrqxufSa9OG3MWkm401qeIszK9rpgDR0jdCo4=";

  buildInputs = [ fuse ];

  tags = [ "jsoniter" ];

  ldflags = [
    "-s"
    "-X \"github.com/OpenListTeam/OpenList/v4/internal/conf.GitAuthor=The OpenList Projects Contributors <noreply@openlist.team>\""
    "-X github.com/OpenListTeam/OpenList/v4/internal/conf.Version=${finalAttrs.version}"
    "-X github.com/OpenListTeam/OpenList/v4/internal/conf.WebVersion=${finalAttrs.frontend.version}"
  ];

  preConfigure = ''
    rm -rf public/dist
    cp -r ${finalAttrs.frontend} public/dist
  '';

  preBuild = ''
    ldflags+=" -X \"github.com/OpenListTeam/OpenList/v4/internal/conf.BuiltAt=$(<SOURCE_DATE_EPOCH)\""
    ldflags+=" -X github.com/OpenListTeam/OpenList/v4/internal/conf.GitCommit=$(<COMMIT)"
  '';

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestHTTPAll"
        "TestWebsocketAll"
        "TestWebsocketCaller"
        "TestDownloadOrder"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd OpenList \
      --bash <($out/bin/OpenList completion bash) \
      --fish <($out/bin/OpenList completion fish) \
      --zsh <($out/bin/OpenList completion zsh)

    mkdir $out/share/powershell/ -p
    $out/bin/OpenList completion powershell > $out/share/powershell/OpenList.Completion.ps1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/OpenList";
  versionCheckProgramArg = "version";

  passthru.updateScript = lib.getExe (callPackage ./update.nix { });

  meta = {
    description = "AList Fork to Anti Trust Crisis";
    homepage = "https://github.com/OpenListTeam/OpenList";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "OpenList";
  };
})
