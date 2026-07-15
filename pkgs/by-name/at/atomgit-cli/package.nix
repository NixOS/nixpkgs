{
  lib,
  stdenv,
  buildGoModule,
  fetchgit,
  gitMinimal,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "atomgit-cli";
  version = "0.5.0";

  src = fetchgit {
    url = "https://atomgit.com/hust-open-atom-club/atomgit-cli.git";
    rev = "11f1ff216053bf47c0a3baaed6698c9222f1ce77";
    hash = "sha256-ZvQ8S0f1jUfN48UE/U+JnTTrtoWYZfwhDPDBbKKLlC0=";
  };

  vendorHash = "sha256-7K17JaXFsjf163g5PXCb5ng2gYdotnZ2IDKk8KFjNj0=";

  subPackages = [ "cmd/ag" ];

  preCheck = ''
    # Test all packages, not only cmd/ag.
    unset subPackages
  '';

  ldflags = [
    "-s"
    "-w"
    "-X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Version=v${finalAttrs.version}"
    "-X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Commit=${finalAttrs.src.rev}"
    "-X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.BuildDate=2026-07-13T07:53:45Z"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/ag \
      --prefix PATH : ${
        lib.makeBinPath ([ gitMinimal ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ])
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Command-line interface for AtomGit";
    homepage = "https://atomgit.com/hust-open-atom-club/atomgit-cli";
    changelog = "https://atomgit.com/hust-open-atom-club/atomgit-cli/tags/v${finalAttrs.version}";
    license = lib.licenses.mulan-psl2;
    mainProgram = "ag";
    maintainers = [ lib.maintainers.silicalet ];
  };
})
