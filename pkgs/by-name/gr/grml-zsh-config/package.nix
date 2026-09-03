{
  stdenv,
  fetchFromGitHub,
  lib,
  asciidoctor,
  txt2tags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "grml-zsh-config";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hxa++tAvuarVkwqqA9///wQ0vjDSXn9GO5cnxaqpdr8=";
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

  meta = {
    description = "grml's zsh setup";
    homepage = "https://grml.org/zsh/";
    license = with lib.licenses; [
      gpl2Plus
      gpl2Only
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      msteen
      rvolosatovs
    ];
  };
})
