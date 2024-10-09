{
  lib,
  fetchPypi,
  python3,
}:
let
  pname = "passhole";
  version = "1.10.0";

  pykeepass-cache = python3.pkgs.buildPythonPackage {
    pname = "pykeepass-cache";
    version = "2.0.3";

    src = fetchPypi {
      pname = "pykeepass-cache";
      version = "2.0.3";
      sha256 = "sha256-fzb+qC8dACPr+V31DV50ElHzIePdXMX6TtepTY6fYeg=";
    };

    dependencies = with python3.pkgs; [
      pykeepass
      rpyc
      python-daemon
    ];
  };
in
python3.pkgs.buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3pNxhqmkw8tO0wVBuZnua64HJrEpyeNSAKiAMsM4oVY=";
  };

  dependencies =
    with python3.pkgs;
    [
      pynput
      pykeepass
      colorama
      future
      pyotp
      qrcode
    ]
    ++ [ pykeepass-cache ];

  checkPhase = ''
    ${python3}/bin/python test/tests.py
  '';

  meta = {
    description = "A secure hole for your passwords (KeePass CLI)";
    homepage = "https://github.com/Evidlo/passhole";
    changelog = "https://github.com/Evidlo/passhole/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ cipher-clone ];
    mainProgram = "ph";
  };
}
