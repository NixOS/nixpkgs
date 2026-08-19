{
  lib,
  stdenv,
  buildGoModule,
  fetchgit,
  gitMinimal,
  gitUpdater,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "atomgit-cli";
  version = "0.7.1";

  src = fetchgit {
    url = "https://atomgit.com/hust-open-atom-club/atomgit-cli.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SyOGkxDgkfQUeaHp6F+FhTLqWYCWvG7RVqVw1wfE1Uw=";
  };

  vendorHash = "sha256-gkVSHoo7BWMy/vSKq2+sgm/TAhC4WYl04OXfG6INrG4=";

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
    "-X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.BuildDate=2026-07-18T16:40:02Z"
  ];

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  postFixup = ''
    wrapProgram $out/bin/ag \
      --prefix PATH : ${
        lib.makeBinPath ([ gitMinimal ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ])
      }
  '';

  nativeInstallCheckInputs = [
    gitMinimal
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
