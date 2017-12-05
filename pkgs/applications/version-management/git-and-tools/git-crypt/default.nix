{ stdenv, fetchFromGitHub, openssl, gnupg1compat, makeWrapper }:

stdenv.mkDerivation rec {

  name = "git-crypt-${meta.version}";

  src = fetchFromGitHub {
    owner = "AGWA";
    repo = "git-crypt";
    rev = meta.version;
    sha256 = "4fe45f903a4b3cc06a5fe11334b914c225009fe8440d9e91a54fdf21cf4dcc4d";
    inherit name;
  };

  buildInputs = [ openssl makeWrapper ];

  installPhase = ''
    make install PREFIX=$out
    wrapProgram $out/bin/* --prefix PATH : ${gnupg1compat}/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.agwa.name/projects/git-crypt;
    description = "Transparent file encryption in git";
    longDescription = ''
      git-crypt enables transparent encryption and decryption of files in a git
      repository. Files which you choose to protect are encrypted when
      committed, and decrypted when checked out. git-crypt lets you freely
      share a repository containing a mix of public and private
      content. git-crypt gracefully degrades, so developers without the secret
      key can still clone and commit to a repository with encrypted files. This
      lets you store your secret material (such as keys or passwords) in the
      same repository as your code, without requiring you to lock down your
      entire repository.
    '';
    downloadPage = "https://github.com/AGWA/git-crypt/releases";
    license = licenses.gpl3;
    version = "0.5.0";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
