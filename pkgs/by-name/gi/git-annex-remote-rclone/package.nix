{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rclone,
  makeWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "git-annex-remote-rclone";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "DanielDent";
    repo = "git-annex-remote-rclone";
    rev = "v${version}";
    sha256 = "sha256-B6x67XXE4BHd3x7a8pQlqPPmpy0c62ziDAldB4QpqQ4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 -t $out/bin git-annex-remote-rclone
    wrapProgram "$out/bin/git-annex-remote-rclone" \
      --prefix PATH ":" "${lib.makeBinPath [ rclone ]}"
  '';

  meta = {
    homepage = "https://github.com/DanielDent/git-annex-remote-rclone";
    description = "Use rclone supported cloud storage providers with git-annex";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.montag451 ];
    mainProgram = "git-annex-remote-rclone";
  };
}
