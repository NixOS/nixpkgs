{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "rclone-${version}";
  version = "1.38";

  goPackagePath = "github.com/ncw/rclone";

  src = fetchFromGitHub {
    owner = "ncw";
    repo = "rclone";
    rev = "v${version}";
    sha256 = "0f56qm4lz55anzqf6dmjfywmvqy10zi5cl69zz8lda8lmvrpjm1d";
  };

  outputs = [ "bin" "out" "man" ];

  postInstall = ''
    install -D -m644 $src/rclone.1 $man/share/man/man1/rclone.1
  '';

  meta = with stdenv.lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = http://rclone.org;
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer ];
    platforms = platforms.all;
  };
}
