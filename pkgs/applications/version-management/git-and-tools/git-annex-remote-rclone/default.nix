{ stdenv, fetchFromGitHub, rclone, makeWrapper }:

stdenv.mkDerivation rec {
  name = "git-annex-remote-rclone-${version}";
  version = "0.5";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "DanielDent";
    repo = "git-annex-remote-rclone";
    sha256 = "1353b6q3lnxhpdfy9yd2af65v7aypdhyvgn7ziksmsrbi12lb74i";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp git-annex-remote-rclone $out/bin
    wrapProgram "$out/bin/git-annex-remote-rclone" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ rclone ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/DanielDent/git-annex-remote-rclone;
    description = "Use rclone supported cloud storage providers with git-annex";
    license = licenses.gpl3;
    maintainers = [ maintainers.montag451 ];
  };
}
