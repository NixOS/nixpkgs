{
  fetchFromGitHub,
  hidapi,
  kmod,
  lib,
  python3,
  toybox,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "3.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    rev = "refs/tags/v${version}";
    hash = "sha256-15vG+e509CEagZ+G9FcfRmsdD8Jex8xUfdvEKlY+FaI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    evdev
    hidapi
    kmod
    pyyaml
    rich
    setuptools
    toybox
    xlib
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  postPatch = ''
    # handheld-daemon contains a fork of the python module `hid`, so this hook
    # is borrowed from the `hid` derivation.
    hidapi=${hidapi}/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" src/hhd/controller/lib/hid.py

    # The generated udev rules point to /bin/chmod, which does not exist in NixOS
    chmod=${toybox}/bin/chmod
    sed -i -e "s|/bin/chmod|$chmod|" src/hhd/controller/lib/hide.py
  '';

  postInstall = ''
    install -Dm644 $src/usr/lib/udev/rules.d/83-hhd.rules -t $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/hhd/";
    description = "Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ appsforartists toast ];
    mainProgram = "hhd";
  };
}
