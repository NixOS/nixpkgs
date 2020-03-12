{ stdenv, fetchFromGitHub, docutils, makeWrapper
, gnupg, curl, rsync, coreutils
, gawk, gnused, gnugrep
}:

stdenv.mkDerivation rec {
  pname = "git-remote-gcrypt";
  version = "1.3";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "spwhitton";
    repo = "git-remote-gcrypt";
    sha256 = "0n8fzvr6y0pxrbvkywlky2bd8jvi0ayp4n9hwi84l1ldmv4a40dh";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ docutils makeWrapper ];

  installPhase = ''
    prefix="$out" ./install.sh
    wrapProgram "$out/bin/git-remote-gcrypt" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg curl rsync coreutils
                                                    gawk gnused gnugrep ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://spwhitton.name/tech/code/git-remote-gcrypt;
    description = "A git remote helper for GPG-encrypted remotes";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ellis montag451 ];
    platforms = platforms.unix;
  };
}
