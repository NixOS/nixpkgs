{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "i3-wk-switch";
  version = "2017-08-21";

  # https://github.com/tmfink/i3-wk-switch/commit/484f840bc4c28ddc60fa3be81e2098f7689e78fb
  src = fetchFromGitHub {
    owner = "tmfink";
    repo = pname;
    rev = "484f840";
    sha256 = "0nrc13ld5bx07wrgnpzgpbaixb4rpi93xiapvyb8srd49fj9pcmb";
  };

  propagatedBuildInputs = with python2Packages; [ i3-py ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    cp i3-wk-switch.py "$out/bin/i3-wk-switch"
  '';

  meta = with stdenv.lib; {
    description = "XMonad-like workspace switching for i3";
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://travisf.net/i3-wk-switcher;
  };
}
