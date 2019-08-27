{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rclone";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "13xzz6nl4863dyn9w1qczap77bbiwzp4znbifa9hg91qys0nj5ga";
  };

  modSha256 = "158mpmy8q67dk1ks9p926n1670gsk7rhd0vpjh44f4g64ddnhk03";

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
