{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonPackage {
  pname = "edl";
<<<<<<< HEAD
  version = "3.52.1-unstable-2025-12-17";
=======
  version = "3.52.1-unstable-2025-09-10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "edl";
<<<<<<< HEAD
    rev = "dffc6833ad51fb7e561c7c2bd26057edd18d9f7a";
    fetchSubmodules = true;
    hash = "sha256-wdcA+pw7kUA7kSWIv6Wi+vmFFWGuC5LLds1oeEeGpOE=";
=======
    rev = "334028cd887a2960867750c403dbcad9cbe8c46b";
    fetchSubmodules = true;
    hash = "sha256-OYrncVbCJkeONeztfj7cB3QW1Q0tlF1b/LeuMqKiblk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = with python3Packages; [
    pyusb
    pyserial
    docopt
    pylzma
    pycryptodome
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/bkerler/edl";
    description = "Qualcomm EDL tool (Sahara / Firehose / Diag)";
    # See https://github.com/NixOS/nixpkgs/issues/348931
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/bkerler/edl";
    description = "Qualcomm EDL tool (Sahara / Firehose / Diag)";
    # See https://github.com/NixOS/nixpkgs/issues/348931
    license = licenses.unfree;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lorenz
      xddxdd
    ];
    # Case-sensitive files in 'Loader' submodule
    broken = stdenv.hostPlatform.isDarwin;
  };
}
