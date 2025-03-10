{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "enchive";
  version = "3.5";
  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "enchive";
    rev = version;
    sha256 = "0fdrfc5l42lj2bvmv9dmkmhmm7qiszwk7cmdvnqad3fs7652g0qa";
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
}
