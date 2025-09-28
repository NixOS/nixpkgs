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
  fuse,
  fuse3,
  macfuse-stubs,
  librclone,
  nix-update-script,
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.71.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone";
    tag = "v${version}";
    hash = "sha256-CvU07yzqBtQVjNtwnOLnSwULNkDMSmNTNyLFpDYy/w4=";
  };

  vendorHash = "sha256-Hapwa+WYz6a22HauRjRUl7q0ZlwR/j/zwex0VebgC+g=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optional enableCmount (
    if stdenv.hostPlatform.isDarwin then macfuse-stubs else fuse
  );

  tags = lib.optionals enableCmount [ "cmount" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/rclone/rclone/fs.Version=${src.tag}"
  ];

  postConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace vendor/github.com/winfsp/cgofuse/fuse/host_cgo.go \
        --replace-fail '"libfuse.so.2"' '"${lib.getLib fuse}/lib/libfuse.so.2"'
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
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
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
    changelog = "https://github.com/rclone/rclone/blob/v${version}/docs/content/changelog.md";
    license = lib.licenses.mit;
    mainProgram = "rclone";
    maintainers = with lib.maintainers; [
      SuperSandro2000
    ];
  };
}
