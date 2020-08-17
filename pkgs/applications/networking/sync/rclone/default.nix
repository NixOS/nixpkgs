{ stdenv, buildGoPackage, fetchFromGitHub, buildPackages, installShellFiles }:

buildGoPackage rec {
  pname = "rclone";
  version = "1.52.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1bf3rhs4dcb8vkzs4a6pk5xrhnkhqsrbf4xrhcqf407r668gdav1";
  };

  goPackagePath = "github.com/rclone/rclone";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform == stdenv.hostPlatform
        then "$out"
        else stdenv.lib.getBin buildPackages.rclone;
    in
      ''
        installManPage $src/rclone.1
        for shell in bash zsh fish; do
          ${rcloneBin}/bin/rclone genautocomplete $shell rclone.$shell
          installShellCompletion rclone.$shell
        done
      '';

  meta = with stdenv.lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer marsam ];
  };
}
