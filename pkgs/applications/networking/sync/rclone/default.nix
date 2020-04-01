{ stdenv, buildGoPackage, fetchFromGitHub, buildPackages }:

buildGoPackage rec {
  pname = "rclone";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0z4kaq6wnj5dgl52g7f86phxlvnk5pbpda7prgh3hahpyhxj0z7d";
  };

  goPackagePath = "github.com/rclone/rclone";

  subPackages = [ "." ];

  outputs = [ "bin" "out" "man" ];

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform == stdenv.hostPlatform
        then "$bin"
        else stdenv.lib.getBin buildPackages.rclone;
    in
      ''
        install -D -m644 $src/rclone.1 $man/share/man/man1/rclone.1
        mkdir -p $bin/share/zsh/site-functions $bin/share/bash-completion/completions/
        ${rcloneBin}/bin/rclone genautocomplete zsh $bin/share/zsh/site-functions/_rclone
        ${rcloneBin}/bin/rclone genautocomplete bash $bin/share/bash-completion/completions/rclone.bash
      '';

  meta = with stdenv.lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = https://rclone.org;
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer ];
    platforms = platforms.all;
  };
}
