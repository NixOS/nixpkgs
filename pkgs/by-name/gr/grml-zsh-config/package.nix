{
  stdenv,
  fetchFromGitHub,
  lib,
  asciidoctor,
  txt2tags,
}:
stdenv.mkDerivation rec {
  pname = "grml-zsh-config";
<<<<<<< HEAD
  version = "0.19.26";
=======
  version = "0.19.25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-WZ3eyX9ijsU221I4hEhWUtFmtBQ9jm1QvQZh20gcR/s=";
=======
    sha256 = "sha256-jUdgigqK6j7Tn/Gl737iNSitUyp7uWrXfRyCBxUSD/0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "grml's zsh setup";
    homepage = "https://grml.org/zsh/";
    license = with lib.licenses; [
      gpl2Plus
      gpl2Only
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "grml's zsh setup";
    homepage = "https://grml.org/zsh/";
    license = with licenses; [
      gpl2Plus
      gpl2Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      msteen
      rvolosatovs
    ];
  };
}
