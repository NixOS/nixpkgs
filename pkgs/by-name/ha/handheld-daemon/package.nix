{ config
, fetchFromGitHub
, hidapi
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "1.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    rev = "6cb83a9833eebc81bd27bed57eb68ece15cdd7a6";
    hash = "sha256-YfBi5UKaB+v+eDI8rcvqkogAYRU2kTc0NqvakhKxBOE=";
  };

  pythonPath = with python3.pkgs; [
    evdev
    pyyaml
    rich
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = [
    hidapi
  ];

  # handheld-daemon contains a fork of the python module `hid`, so this hook
  # is borrowed from the `hid` derivation.
  postPatch = ''
    hidapi=${ hidapi }/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" src/hhd/controller/lib/hid.py
  '';

  postInstall = ''
    install -Dm644 $src/usr/lib/udev/rules.d/83-hhd.rules -t $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/hhd/";
    description = "Linux support for gaming handhelds";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ appsforartists ];
    mainProgram = "hhd";
  };
}
