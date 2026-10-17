{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enchive";
  version = "3.5";
  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "enchive";
    rev = finalAttrs.version;
    hash = "sha256-CoMnijnajaaw3a2yM/nXEZ9aYZ21pV33EpIKQgtzuTk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v "$src/enchive-mode.el" "$out/share/emacs/site-lisp/"
  '';

  meta = {
    description = "Encrypted personal archives";
    mainProgram = "enchive";
    homepage = "https://github.com/skeeto/enchive";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.nico202 ];
  };
})
