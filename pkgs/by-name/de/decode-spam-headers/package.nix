{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "decode-spam-headers";
  version = "2022-09-22-unreleased";

  src = fetchFromGitHub {
    owner = "mgeeky";
    repo = "decode-spam-headers";
    rev = "492b6e744475cd5d3dd68a8140bc3478244b7df1";
    sha256 = "sha256-gBDkvlZCndQjochn6TZtM/Lanza64LqMjNnLjn+pPR4=";
  };

  format = "other";

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    install -D decode-spam-headers.py $out/bin/decode-spam-headers

    mkdir -p $doc/share/doc/${pname}
    mv \
      README.md \
      img/ \
      $doc/share/doc/${pname}
  '';

  propagatedBuildInputs = [
    python3Packages.python-dateutil
    python3Packages.tldextract
    python3Packages.packaging
    python3Packages.dnspython
    python3Packages.requests
    python3Packages.colorama
  ];

  meta = with lib; {
    homepage = "https://github.com/mgeeky/decode-spam-headers/";
    description = "Script that helps you understand why your E-Mail ended up in Spam";
    mainProgram = "decode-spam-headers";
    longDescription = ''
      Whether you are trying to understand why a specific e-mail ended up in
      SPAM/Junk for your daily Administrative duties or for your Red-Team
      Phishing simulation purposes, this script is there for you to help!

      This tool accepts on input an *.EML or *.txt file with all the SMTP
      headers. It will then extract a subset of interesting headers and using
      105+ tests will attempt to decode them as much as possible.

      This script also extracts all IPv4 addresses and domain names and performs
      full DNS resolution of them.

      Resulting output will contain useful information on why this e-mail might
      have been blocked.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
