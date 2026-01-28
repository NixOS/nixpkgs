{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonPackage {
  pname = "edl";
  version = "3.52.1-unstable-2026-01-22";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "edl";
    rev = "fa61cc9cadf9a2023ab21ed3887648067ff8514f";
    fetchSubmodules = true;
    hash = "sha256-zrEobpK4BiN5VgLVfLRliyJUFi0POqI7APLsuehk1Ic=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyusb
    pyserial
    docopt
    pycryptodomex
    lxml
    colorama
    capstone
    keystone-engine
  ];

  # No tests set up
  doCheck = false;
  # EDL loaders are ELFs but shouldn't be touched, rest is Python anyways
  dontStrip = true;

  # edl has a spurious dependency on "usb" which has nothing to do with the
  # project and was probably added by accident trying to add pyusb
  postPatch = ''
    sed -i '/'usb'/d' setup.py
  '';

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src/Drivers/51-edl.rules $out/etc/udev/rules.d/51-edl.rules
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/bkerler/edl";
    description = "Qualcomm EDL tool (Sahara / Firehose / Diag)";
    # See https://github.com/NixOS/nixpkgs/issues/348931
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      lorenz
      xddxdd
    ];
    # Case-sensitive files in 'Loader' submodule
    broken = stdenv.hostPlatform.isDarwin;
  };
}
