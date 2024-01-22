{ config
, fetchFromGitHub
, hidapi
, kmod
, lib
, python3
, toybox
}:
python3.pkgs.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    rev = "abe34c6841476f5b41afe30ee18ff3e510402d68";
    hash = "sha256-ovLC1BQ98jUaDEMPBzWma4TYSzTF+yE/cMemFdJmqlE=";
  };

  pythonPath = with python3.pkgs; [
    evdev
    pyyaml
    rich
  ];

  propagatedBuildInputs = with python3.pkgs; [
    hidapi
    kmod
    setuptools
    toybox
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
