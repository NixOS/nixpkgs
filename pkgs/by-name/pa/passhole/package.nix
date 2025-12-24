{
  lib,
  fetchPypi,
  fetchurl,
  python3,
  stdenv,
}:
let
  pname = "passhole";
  version = "1.10.0";

  pykeepass-cache = python3.pkgs.buildPythonPackage {
    pname = "pykeepass-cache";
    version = "2.0.3";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/48/55/463eb873b9ef80fc8309d1683ab01d1d8fb896b2631550e83e26d7e88dae/pykeepass-cache-2.0.3.tar.gz";
      hash = "sha256-fzb+qC8dACPr+V31DV50ElHzIePdXMX6TtepTY6fYeg=";
    };

    dependencies = with python3.pkgs; [
      pykeepass
      rpyc
      python-daemon
    ];
  };

  passhole = python3.pkgs.buildPythonPackage rec {
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

    doCheck = true;
    checkPhase = ''
      ${python3}/bin/python test/tests.py
    '';
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = passhole;
  installPhase = ''
    mkdir $out
    cp -rv ${passhole}/bin $out
  '';

  meta = with lib; {
    description = "Secure hole for your passwords (KeePass CLI)";
    homepage = "https://github.com/Evidlo/passhole";
    license = licenses.gpl3;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ cipher-clone ];
  };
}
