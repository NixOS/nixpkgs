{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles
, makeWrapper
, enableCmount ? true, fuse, macfuse-stubs
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.59.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SHUAEjdcqzNiIxSsmYb71JiOhWPoi8Z2nJAReRw2M5k=";
  };

  vendorSha256 = "sha256-ajOUvZ/0D8QL4MY6xO+hZziyUtIB0WQERU6Ov06K9I8=";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  buildInputs = lib.optional enableCmount (if stdenv.isDarwin then macfuse-stubs else fuse);
  nativeBuildInputs = [ installShellFiles makeWrapper ];

  tags = lib.optionals enableCmount [ "cmount" ];

  ldflags = [ "-s" "-w" "-X github.com/rclone/rclone/fs.Version=${version}" ];

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform == stdenv.hostPlatform
        then "$out"
        else lib.getBin buildPackages.rclone;
    in
    ''
      installManPage rclone.1
      for shell in bash zsh fish; do
        ${rcloneBin}/bin/rclone genautocomplete $shell rclone.$shell
        installShellCompletion rclone.$shell
      done
    '' + lib.optionalString (enableCmount && !stdenv.isDarwin)
      # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount,
      # as the setuid wrapper is required as non-root on NixOS.
      ''
      wrapProgram $out/bin/rclone \
                  --suffix PATH : "${lib.makeBinPath [ fuse ] }" \
                  --prefix LD_LIBRARY_PATH : "${fuse}/lib"
    '';

  meta = with lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${version}/docs/content/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer marsam SuperSandro2000 ];
  };
}
