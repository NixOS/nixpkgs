{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "i3-wk-switch";
  version = "2020-03-18";
  format = "other";

  src = fetchFromGitHub {
    owner = "tmfink";
    repo = "i3-wk-switch";
    rev = "a618cb8f52120aa8d533bb7c0c8de3ff13b3dc06";
    sha256 = "0ci0w5igjk5xa8x4rx17cpgmdkamwjmavxhp0vp6213cl93ybjhz";
  };

  propagatedBuildInputs = with python3Packages; [ i3ipc ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    cp i3-wk-switch.py "$out/bin/i3-wk-switch"
  '';

  meta = with lib; {
    description = "XMonad-like workspace switching for i3 and sway";
    mainProgram = "i3-wk-switch";
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = "https://travisf.net/i3-wk-switcher";
  };
}
