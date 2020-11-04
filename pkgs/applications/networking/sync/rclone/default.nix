{ stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles }:

buildGoModule rec {
  pname = "rclone";
  version = "1.53.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0ns55b6s4zdw94jlialps3knclghj9xqx84ff8hyrl9ksq02kd3w";
  };

  vendorSha256 = "1l4iz31k1pylvf0zrp4nhxna70s1ma4981x6q1s3dhszjxil5c88";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/rclone/rclone/fs.Version=${version}" ];

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform == stdenv.hostPlatform
        then "$out"
        else stdenv.lib.getBin buildPackages.rclone;
    in
    ''
      installManPage rclone.1
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
