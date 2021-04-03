{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles }:

buildGoModule rec {
  pname = "rclone";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "01pvcns3n735s848wc11q40pkkv646gn3cxkma866k44a9c2wirl";
  };

  vendorSha256 = "05f9nx5sa35q2szfkmnkhvqli8jlqja8ghiwyxk7cvgjl7fgd6zk";

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
