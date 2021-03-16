{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles }:

buildGoModule rec {
  pname = "rclone";
  version = "1.54.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DexqYAkGmgROnYpknnuWc3Q//IMOTSxgrr1w/TrueH4=";
  };

  vendorSha256 = "sha256-Cpn/dUD9E2BzUlAISC+IDCW59OkEKZTpqdlvF/clV+M=";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/rclone/rclone/fs.Version=${version}" ];

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
    '';

  meta = with lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${version}/docs/content/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer marsam SuperSandro2000 ];
  };
}
