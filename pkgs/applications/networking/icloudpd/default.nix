{ lib
, stdenv
, fetchFromGitHub
, python3Packages
, nix-update-script
, icloudpd
, testers
}:

python3Packages.buildPythonPackage rec {
  pname = "icloudpd";
  version = "1.15.1";
  format = "pyproject";

  src =  fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    rev = "v${version}";
    sha256 = "sha256-nKtV9VGcEiIVfg1XeHzIw9kr2pp4aHugfjVK03iPDR8=";
  };

  propagatedBuildInputs = with python3Packages; [
    wheel
    setuptools
    requests
    schema
    click
    python-dateutil
    tqdm
    piexif
    urllib3
    six
    tzlocal
    pytz
    certifi
    future
    keyring
    keyrings-alt
    pytest
    mock
    freezegun
    vcrpy
    pytest-cov
    pylint
    coveralls
    autopep8
    pytest-timeout
    pytest-xdist
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = icloudpd; };
  };

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace "certifi>=2022.12.7,<2023" "certifi" \
      --replace "urllib3>=1.26.14,<2" "urllib3" \
      --replace "pytz>=2022.7.1,<2023" "pytz"
  '';
  doCheck = false;
  meta = with lib; {
    homepage = "https://github.com/icloud-photos-downloader/icloud_photos_downloader";
    description = "iCloud Photos Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ anpin ];
  };
}
