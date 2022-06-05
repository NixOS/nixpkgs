{ fetchFromGitHub
, git
, gnupg
, makeWrapper
, openssl
, lib
, stdenv
, libxslt
, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "git-crypt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "AGWA";
    repo = pname;
    rev = version;
    sha256 = "sha256-GcGCX6hoKL+sNLAeGEzZpaM+cdFjcNlwYExfOFEPi0I=";
  };

  strictDeps = true;

  nativeBuildInputs = [ libxslt makeWrapper ];

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace commands.cpp \
      --replace '(escape_shell_arg(our_exe_path()))' '= "git-crypt"'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ENABLE_MAN=yes"
    "DOCBOOK_XSL=${docbook_xsl}/share/xml/docbook-xsl-nons/manpages/docbook.xsl"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-crypt \
      --suffix PATH : ${lib.makeBinPath [ git gnupg ]}
  '';

  meta = with lib; {
    homepage = "https://www.agwa.name/projects/git-crypt";
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
    maintainers = with maintainers; [ dochang SuperSandro2000 ];
    platforms = platforms.unix;
  };

}
