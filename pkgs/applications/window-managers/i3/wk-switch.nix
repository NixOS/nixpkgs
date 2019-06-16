{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "i3-wk-switch";
  version = "2019-06-14";

  src = fetchFromGitHub {
    owner = "tmfink";
    repo = pname;
    rev = "522b63f6d265e0b7108a7f26fb0ce76810a2f480";
    sha256 = "0m9zdj7w9z93lcrdgpflrqn1cnp91ann3jf1l4ipjl1nzz2kin13";
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
