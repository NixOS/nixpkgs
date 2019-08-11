{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "i3-wk-switch";
  version = "2019-05-10";

  src = fetchFromGitHub {
    owner = "tmfink";
    repo = pname;
    rev = "05a2d5d35e9841d2a26630f1866fc0a0e8e708eb";
    sha256 = "0ln192abdqrrs7rdazp9acbji2y6pf68z2d1by4nf2q529dh24dc";
  };

  propagatedBuildInputs = with python3Packages; [ i3ipc ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    cp i3-wk-switch.py "$out/bin/i3-wk-switch"
  '';

  meta = with stdenv.lib; {
    description = "XMonad-like workspace switching for i3 and sway";
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://travisf.net/i3-wk-switcher;
  };
}
