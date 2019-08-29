{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rclone";
  version = "1.49.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0mjwp1j70dqa8k3zxhcnw85ddhagkpr7c59mv8kradv6mqqzmq9c";
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
