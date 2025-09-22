{
  stdenv,
  fetchFromGitHub,
  lib,
  asciidoctor,
  txt2tags,
}:
stdenv.mkDerivation rec {
  pname = "grml-zsh-config";
  version = "0.19.24";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
    sha256 = "sha256-DUkj/5LD85h3J+PIVAfsGY0fkktAgWn93Y3hnRrn/wk=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    asciidoctor
    txt2tags
  ];

  buildPhase = ''
    cd doc
    make
    cd ..
  '';

  installPhase = ''
    install -D -m644 etc/zsh/keephack $out/etc/zsh/keephack
    install -D -m644 etc/zsh/zshrc $out/etc/zsh/zshrc

    install -D -m644 doc/grmlzshrc.5 $out/share/man/man5/grmlzshrc.5
    ln -s grmlzshrc.5.gz $out/share/man/man5/grml-zsh-config.5.gz
  '';

  meta = with lib; {
    description = "grml's zsh setup";
    homepage = "https://grml.org/zsh/";
    license = with licenses; [
      gpl2Plus
      gpl2Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      msteen
      rvolosatovs
    ];
  };
}
