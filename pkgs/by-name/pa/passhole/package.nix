{
  lib,
  fetchPypi,
  python3Packages,
  nix-update-script,
  fetchpatch2,
}:

let
  inherit (python3Packages)
    pynput
    pykeepass
    pykeepass-cache
    colorama
    pyotp
    qrcode
    buildPythonApplication
    setuptools
    ;
in

buildPythonApplication rec {
  pname = "passhole";
  version = "1.10.1";

  patches = [
    # Until version v1.10.2 or later is released, passhole's dependencies
    # include "future", an vestigial Python2 compatibility layer.
    # The inclusion of this dependency breaks the build on newer versions
    # of Python, so we remove it here.
    #
    # Once this patch is included in an upstream release, it can be safely
    # removed from here.
    (fetchpatch2 {
      name = "remove-future-dependency.patch";
      url = "https://github.com/Evidlo/passhole/commit/a6d688af8cdfec0d33fddf6c18a72aeea154d207.patch?full_index=1";
      sha256 = "AF2dGFlkaIgvLjtE6Wnp20G7e3EVPouZC9HYQyuZKhE=";
    })
  ];
  src = fetchPypi {
    inherit pname version;
    sha256 = "5x8RA5H0DxAAI0deLXhUSy+q5vGixCWHU4d9FYXRcdE=";
  };
  propagatedBuildInputs = [
    pynput
    pykeepass
    pykeepass-cache
    colorama
    pyotp
    qrcode
  ];

  pythonImportsCheck = [ "passhole" ];
  pyproject = true;
  build-system = [ setuptools ];

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    homepage = "https://github.com/Evidlo/passhole";
    description = "CLI KeePass client with dmenu support";
    license = licenses.gpl3Only;
    maintainers = [ lib.maintainers.alch-emi ];
    platforms = lib.platforms.linux;
    mainProgram = "passhole"; # Also available as the "ph" alias
    changelog = "https://github.com/Evidlo/passhole/blob/master/CHANGELOG.rst";
  };
}
