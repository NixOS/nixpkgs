{ lib, stdenv, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
<<<<<<< HEAD
  version = "0.6.26";
=======
  version = "0.6.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Tj64/8uYEy4qZISjmtpOGTMzgSkBB516/Dej6/biYRY=";
=======
    hash = "sha256-em9Bfrk7jJdmg3N+zH0VTpCdKPEOBK8vc297V5vmKzM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  subPackages = ["."];

  buildInputs = [
    docker
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/fn
  '';

  meta = with lib; {
    description = "Command-line tool for the fn project";
    homepage = "https://fnproject.io";
    license = licenses.asl20;
    maintainers = [ maintainers.c4605 ];
  };
}
