{ lib, stdenvNoCC, fetchFromGitHub, rclone, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "git-annex-remote-rclone";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "DanielDent";
    repo = "git-annex-remote-rclone";
    rev = "v${version}";
    sha256 = "sha256-H2C4zjM+kbC9qPl1F+bSnepuqANjZd1sz6XxOTkVVkU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 -t $out/bin git-annex-remote-rclone
    wrapProgram "$out/bin/git-annex-remote-rclone" \
      --prefix PATH ":" "${lib.makeBinPath [ rclone ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/DanielDent/git-annex-remote-rclone";
    description = "Use rclone supported cloud storage providers with git-annex";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.montag451 ];
  };
}
