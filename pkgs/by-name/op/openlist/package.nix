{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  buildPackages,
  installShellFiles,
  versionCheckHook,
  fuse,
}:

buildGoModule (finalAttrs: {
  pname = "openlist";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PqCGA2DAfZvDqdnQzqlmz2vlybYokJe+Ybzp5BcJDGU=";
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
  vendorHash = "sha256-e1glgNp5aYl1cEuLdMMLa8sE9lSuiLVdPCX9pek5grE=";

  buildInputs = [ fuse ];

  tags = [ "jsoniter" ];

  ldflags = [
    "-s"
    "-X \"github.com/OpenListTeam/OpenList/internal/conf.GitAuthor=The OpenList Projects Contributors <noreply@openlist.team>\""
    "-X github.com/OpenListTeam/OpenList/internal/conf.Version=${finalAttrs.version}"
    "-X github.com/OpenListTeam/OpenList/internal/conf.WebVersion=${finalAttrs.frontend.version}"
  ];

  preConfigure = ''
    rm -rf public/dist
    cp -r ${finalAttrs.frontend} public/dist
  '';

  preBuild = ''
    ldflags+=" -X \"github.com/OpenListTeam/OpenList/internal/conf.BuiltAt=$(<SOURCE_DATE_EPOCH)\""
    ldflags+=" -X github.com/OpenListTeam/OpenList/internal/conf.GitCommit=$(<COMMIT)"
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

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd OpenList \
        --bash <(${emulator} $out/bin/OpenList completion bash) \
        --fish <(${emulator} $out/bin/OpenList completion fish) \
        --zsh <(${emulator} $out/bin/OpenList completion zsh)

      mkdir $out/share/powershell/ -p
      ${emulator} $out/bin/OpenList completion powershell > $out/share/powershell/OpenList.Completion.ps1
    ''
  );

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
