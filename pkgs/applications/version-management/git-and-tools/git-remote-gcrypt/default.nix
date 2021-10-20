{ lib, stdenv, fetchFromGitHub, docutils, makeWrapper
, gnupg, curl, rsync, coreutils
, gawk, gnused, gnugrep
}:

stdenv.mkDerivation rec {
  pname = "git-remote-gcrypt";
  version = "1.4";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "spwhitton";
    repo = "git-remote-gcrypt";
    sha256 = "sha256-uHgz8Aj5w8UOo/XbptCRKON1RAdDfFsLL9ZDEF1QrPQ=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ docutils makeWrapper ];

  installPhase = ''
    prefix="$out" ./install.sh
    wrapProgram "$out/bin/git-remote-gcrypt" \
      --prefix PATH ":" "${lib.makeBinPath [ gnupg curl rsync coreutils
                                                    gawk gnused gnugrep ]}"
  '';

  meta = with lib; {
    homepage = "https://spwhitton.name/tech/code/git-remote-gcrypt";
    description = "A git remote helper for GPG-encrypted remotes";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ellis montag451 ];
    platforms = platforms.unix;
  };
}
