{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildPackages,
  installShellFiles,
  makeWrapper,
  enableCmount ? true,
  fuse,
  fuse3,
  macfuse-stubs,
  librclone,
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.66.0";

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone";
    rev = "v${version}";
    hash = "sha256-75RnAROICtRUDn95gSCNO0F6wes4CkJteNfUN38GQIY=";
  };

  patches = [
    ./CVE-2024-52522.patch
  ];

  vendorHash = "sha256-zGBwgIuabLDqWbutvPHDbPRo5Dd9kNfmgToZXy7KVgI=";

  subPackages = [ "." ];

  outputs = [
    "out"
    "man"
  ];

  buildInputs = lib.optional enableCmount (if stdenv.isDarwin then macfuse-stubs else fuse);
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  tags = lib.optionals enableCmount [ "cmount" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/rclone/rclone/fs.Version=${version}"
  ];

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
      lib.optionalString (enableCmount && !stdenv.isDarwin)
        # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount3,
        # as the setuid wrapper is required as non-root on NixOS.
        ''
          wrapProgram $out/bin/rclone \
            --suffix PATH : "${lib.makeBinPath [ fuse3 ]}" \
            --prefix LD_LIBRARY_PATH : "${fuse3}/lib"
        '';

  passthru.tests = {
    inherit librclone;
  };

  meta = with lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${version}/docs/content/changelog.md";
    license = licenses.mit;
    mainProgram = "rclone";
    maintainers = with maintainers; [
      SuperSandro2000
      tomfitzhenry
    ];
  };
}
