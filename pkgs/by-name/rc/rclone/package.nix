{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildPackages,
  installShellFiles,
  versionCheckHook,
  makeWrapper,
  enableCmount ? true,
  fuse3,
  macfuse-stubs,
  librclone,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "rclone";
  version = "1.74.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GLl8juSCVKEjsVZAzvvfKx1TxC/rcM7lMBek9BLosi0=";
  };

  vendorHash = "sha256-FuSqI5fCmt/fr4AwJhdFaolYugZDTYeOcity/VZzYZ0=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optional enableCmount (
    # cgofuse uses the fuse2 header locations on darwin
    if stdenv.hostPlatform.isDarwin then (macfuse-stubs.override { isFuse3 = false; }) else fuse3
  );

  tags =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [ "fuse3" ]
    ++ lib.optionals enableCmount [ "cmount" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/rclone/rclone/fs.Version=${finalAttrs.src.tag}"
  ];

  postConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace vendor/github.com/winfsp/cgofuse/fuse/host_cgo.go \
        --replace-fail "fuse.h" "fuse3/fuse.h"
  '';

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.rclone;
    in
    ''
      installManPage rclone.1
      for shell in bash zsh fish; do
        ${rcloneBin}/bin/rclone genautocomplete $shell rclone.$shell
        installShellCompletion rclone.$shell
      done

      # filesystem helpers
      ln -s $out/bin/rclone $out/bin/rclonefs
      ln -s $out/bin/rclone $out/bin/mount.rclone
    ''
    +
      lib.optionalString (enableCmount && !stdenv.hostPlatform.isDarwin)
        # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount3,
        # as the setuid wrapper is required as non-root on NixOS.
        ''
          wrapProgram $out/bin/rclone \
            --suffix PATH : "${lib.makeBinPath [ fuse3 ]}"
        '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";

  passthru = {
    tests = {
      inherit librclone;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${finalAttrs.version}/docs/content/changelog.md";
    license = lib.licenses.mit;
    mainProgram = "rclone";
    maintainers = with lib.maintainers; [
      SuperSandro2000
    ];
  };
})
