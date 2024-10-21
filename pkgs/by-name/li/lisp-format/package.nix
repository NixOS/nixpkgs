{
  stdenv,
  lib,
  emacs,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lisp-format";
  version = "0-unstable-2022-02-17";

  src = fetchFromGitHub {
    owner = "eschulte";
    repo = "lisp-format";
    rev = "088c8f78ca41204b44f2636275517ac09a2de6a9";
    hash = "sha256-L2Wl+UWQSiJYvzctyXrMQNViZiZ6Q5vgek1PWkIaTn4=";
  };

  buildInputs = [
    emacs
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm744 lisp-format $out/bin/lisp-format
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
    description = "A tool to format lisp code";
    homepage = "https://github.com/eschulte/lisp-format";
    maintainers = with lib.maintainers; [ haruki7049 ];
    license = lib.licenses.unfree;
  };
}
