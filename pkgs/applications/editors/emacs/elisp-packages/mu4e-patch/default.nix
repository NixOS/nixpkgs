{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "mu4e-patch";
  version = "2019-05-09";

  src = fetchFromGitHub {
    owner = "seanfarley";
    repo = "mu4e-patch";
    rev = "522da46c1653b1cacc79cde91d6534da7ae9517d";
    sha256 = "sha256-1lV4dDuCdyCUXi/In2DzYJPEHuAc9Jfbz2ZecNZwn4I=";
  };

  buildInputs = [
    emacs
  ];

  buildPhase = ''
    runHook preBuild
    emacs -L . --batch -f batch-byte-compile *.el
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = {
    description = "Colorize patch emails in mu4e";
    homepage = "https://github.com/seanfarley/mu4e-patch";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
