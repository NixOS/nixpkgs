{ lib, stdenv, fetchFromGitHub, rclone, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "git-annex-remote-rclone";
  version = "0.7";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "DanielDent";
    repo = "git-annex-remote-rclone";
    sha256 = "sha256-H2C4zjM+kbC9qPl1F+bSnepuqANjZd1sz6XxOTkVVkU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp git-annex-remote-rclone $out/bin
    wrapProgram "$out/bin/git-annex-remote-rclone" \
      --prefix PATH ":" "${lib.makeBinPath [ rclone ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/DanielDent/git-annex-remote-rclone";
    description = "Use rclone supported cloud storage providers with git-annex";
    license = licenses.gpl3;
    maintainers = [ maintainers.montag451 ];
  };
}
