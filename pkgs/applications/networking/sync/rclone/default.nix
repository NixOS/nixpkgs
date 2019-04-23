{ stdenv, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "rclone";
  version = "1.47.0";

  src = fetchFromGitHub {
    owner = "ncw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nxwjr9jly6wh1ixr6a7zhlg4b3298v940040fsm0n3lcljd37zx";
  };

  modSha256 = "02p5dd450bbfyq80nd0w8f9kpv25k1855mf0gcv0cy9zq3f3r7q7";

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
