{ lib, fetchPypi, fetchFromGitHub, python3, qt5, rustPlatform }:

let
  pypdf2 = python3.pkgs.pypdf2.overrideAttrs (oldAttrs: rec {
    pname = "PyPDF2";
    version = "1.28.4";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-BM5CzQVweIH+28oxZHRFEYBf6MMGGK5M+yuUDjNo1a0=";
    };
    # Tests broken on Python 3.x
    unittestCheckPhase = "true";
    doCheck = false;
  });
  librdp = rustPlatform.buildRustPackage rec {
    pname = "rdp";
    version = "v0.9.3";

    src = fetchFromGitHub {
      owner = "urschrei";
      repo = pname;
      rev = version;
      sha256 = "sha256-0gNjQeGscMW93VP312yO55qxtjubh/OFSvE3rDhkKf0=";
    };
    cargoSha256 = "sha256-7L8LqFvxfuwvi3Pj4Vq9WVSLTmvoIHosnHYEMUq6VdE=";
    cargoPatches = [
      ./add-Cargo.lock.patch
    ];

    meta = with lib; {
      description = "A library providing FFI access to fast Ramer–Douglas–Peucker and Visvalingam-Whyatt line simplification algorithms";
      homepage = "https://github.com/urschrei/rdp";
      license = licenses.mit;
      maintainers = [ maintainers.phaer ];
    };
  };
  simplification = python3.pkgs.buildPythonPackage rec {
    pname = "simplification";
    version = "v0.6.2";
    src = fetchFromGitHub {
      owner = "urschrei";
      repo = pname;
      rev = version;
      sha256 = "sha256-e6FyXdBCiwGZZcQeKX9DKzMnwOHNoiEXJlSmsYUSZnE=";
    };
    buildInputs = [librdp];
    doCheck = false;
    propagatedBuildInputs = with python3.pkgs; [
      numpy
      setuptools-scm
      cython
    ];
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "remy";
  version = "df2c1ae";

  src = fetchFromGitHub {
    owner = "bordaigorl";
    repo = "remy";
    rev = "df2c1aec2efe8ba8f1f2ae098478eb8f580188dd";
    sha256 = "sha256-kbeNoQgEJetoStaVodmLVcWWDNj5g4k7r9PdhzAqVvQ=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    simplification
    requests
    sip
    arrow
    paramiko
    pyqt5
    pypdf2
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remy" ];

  preBuild = ''
      ${python3.pkgs.pyqt5}/bin/pyrcc5 -o remy/gui/resources.py resources.qrc
  '';

  postFixup = ''
    wrapQtApp $out/bin/remy
  '';

  meta = with lib; {
    description = "Remy, an online & offline manager for the reMarkable tablet";
    homepage = "https://github.com/bordaigorl/remy";
    license = licenses.gpl3;
    maintainers = [ maintainers.phaer ];
  };
}
