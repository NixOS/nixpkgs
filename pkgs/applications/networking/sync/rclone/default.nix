{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  pname = "rclone";
  version = "1.46";

  goPackagePath = "github.com/ncw/rclone";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ncw";
    repo = "rclone";
    rev = "v${version}";
    sha256 = "1fl52dl41n76r678nzkxa2kgk9khn1fxraxgk8jd3ayc787qs9ia";
  };

  outputs = [ "bin" "out" "man" ];

  # https://github.com/ncw/rclone/issues/2964
  patches = [
    (fetchpatch {
      url = "https://github.com/ncw/rclone/commit/1c1a8ef24bea9332c6c450379ed3c5d953e07508.patch";
      sha256 = "0mq74z78lc3dhama303k712xkzz9q6p7zqlbwbl04bndqlkny03k";
    })
  ];

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
