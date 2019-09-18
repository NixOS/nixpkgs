{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rclone";
  version = "1.49.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0dd5xrbf62n4y77zzaai1rc069ism1ikvcw43hzja3mzwfa0sqqa";
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
