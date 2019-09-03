{ fetchFromGitHub, git, gnupg, makeWrapper, openssl, stdenv
, libxslt, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "git-crypt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "AGWA";
    repo = pname;
    rev = version;
    sha256 = "13m9y0m6gc3mlw3pqv9x4i0him2ycbysizigdvdanhh514kga602";
  };

  nativeBuildInputs = [ libxslt ];

  buildInputs = [ openssl makeWrapper ];

  patchPhase = ''
    substituteInPlace commands.cpp \
      --replace '(escape_shell_arg(our_exe_path()))' '= "git-crypt"'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ENABLE_MAN=yes"
    "DOCBOOK_XSL=${docbook_xsl}/share/xml/docbook-xsl-nons/manpages/docbook.xsl"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-crypt --prefix PATH : $out/bin:${git}/bin:${gnupg}/bin
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
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
