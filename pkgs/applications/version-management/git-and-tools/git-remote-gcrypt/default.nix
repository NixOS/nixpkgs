{ stdenv, fetchFromGitHub, docutils, makeWrapper, gnupg1compat, curl, rsync }:

stdenv.mkDerivation rec {
  name = "git-remote-gcrypt-${version}";
  version = "1.0.0";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "spwhitton";
    repo = "git-remote-gcrypt";
    sha256 = "0c8ig1pdqj7wjwldnf62pmm2x29ri62x6b24mbsl2nxzkqbwh379";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ docutils makeWrapper ];

  installPhase = ''
    prefix="$out" ./install.sh
    wrapProgram "$out/bin/git-remote-gcrypt" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1compat curl rsync ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://spwhitton.name/tech/code/git-remote-gcrypt;
    description = "A git remote helper for GPG-encrypted remotes";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ellis montag451 ];
    platforms = platforms.unix;
  };
}
