{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles
, makeWrapper
, enableCmount ? true, fuse, fuse3, macfuse-stubs
, librclone
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.68.1";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone";
    rev = "v${version}";
    hash = "sha256-qVk1l6PLB2S9KlUiccBN60wbaApZnPXTjq1LYsf7pyE=";
  };

  vendorHash = "sha256-vZxdayoKTo/fs5PgEdT4gepNq0kNNmLQhlybWY5kpx0=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildInputs = lib.optional enableCmount (if stdenv.hostPlatform.isDarwin then macfuse-stubs else fuse);

  tags = lib.optionals enableCmount [ "cmount" ];

  ldflags = [ "-s" "-w" "-X github.com/rclone/rclone/fs.Version=${version}" ];

  postConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace vendor/github.com/winfsp/cgofuse/fuse/host_cgo.go \
        --replace-fail '"libfuse.so.2"' '"${lib.getLib fuse}/lib/libfuse.so.2"'
  '';

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform
        then "$out"
        else lib.getBin buildPackages.rclone;
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
    '' + lib.optionalString (enableCmount && !stdenv.hostPlatform.isDarwin)
      # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount3,
      # as the setuid wrapper is required as non-root on NixOS.
      ''
      wrapProgram $out/bin/rclone \
        --suffix PATH : "${lib.makeBinPath [ fuse3 ] }"
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
    maintainers = with maintainers; [ SuperSandro2000 tomfitzhenry ];
  };
}
