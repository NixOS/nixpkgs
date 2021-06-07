{ lib, stdenv, fetchFromGitHub, python2Packages }:

stdenv.mkDerivation rec {
  pname = "neap";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "vzxwco";
    repo = "neap";
    rev = "v${version}";
    sha256 = "04da8rq23rl1qcvrdm5m3l90xbwyli7x601sckv7hmkip2q3g1kz";
  };

  nativeBuildInputs = [
    python2Packages.wrapPython
  ];

  buildInputs = [
    python2Packages.python
  ];

  pythonPath = [
    python2Packages.xlib
    python2Packages.pygtk
  ];

  installPhase = ''
    install -D -t $out/bin neap
    install -D -t $out/share/man/man1 neap.1
    install -D -t $out/share/applications neap.desktop
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Systray workspace pager";
    homepage = "https://github.com/vzxwco/neap";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
