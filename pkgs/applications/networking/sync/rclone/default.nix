{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rclone";
  version = "1.48.0";

  src = fetchFromGitHub {
    owner = "ncw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wxsn3ynkwh2np12sxdmy435nclg2ry7cw26brz11xc0ri4x9azg";
  };

  modSha256 = "0bbpny7xcwsvhmdypgbbr0gqc5pa40m71qhbps6k0v09rsgqhpn3";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  postInstall = ''
    install -D -m644 $src/rclone.1 $man/share/man/man1/rclone.1
  '';

  meta = with stdenv.lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = https://rclone.org;
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer ];
    platforms = platforms.all;
  };
}
