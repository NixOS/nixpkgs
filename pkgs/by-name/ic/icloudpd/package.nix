{ lib
, python3Packages
, fetchFromGitHub
, nix-update-script
, testers
, icloudpd
}:

python3Packages.buildPythonApplication rec {
  pname = "icloudpd";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    rev = "v${version}";
    hash = "sha256-QVfzGL/W7EmJvGXM8ge4sxWhSyshHYPykudMO1IcZJs=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

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
    keyring
    keyrings-alt
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    freezegun
    vcrpy
    pytest-timeout
  ];

  disabledTests = [
    # touches network
    "test_autodelete_photos"
    "test_download_autodelete_photos"
    "test_retry_delete_after_download_session_error"
    "test_retry_fail_delete_after_download_session_error"
    "test_retry_delete_after_download_internal_error"
    "test_autodelete_photos_dry_run"
    "test_retry_fail_delete_after_download_internal_error"
    "test_autodelete_invalid_creation_date"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = icloudpd; };
  };

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools==69.0.2" "setuptools" \
      --replace "wheel==0.42.0" "wheel"
  '';

  meta = with lib; {
    homepage = "https://github.com/icloud-photos-downloader/icloud_photos_downloader";
    description = "iCloud Photos Downloader";
    license = licenses.mit;
    mainProgram = "icloudpd";
    maintainers = with maintainers; [ anpin Enzime jnsgruk ];
  };
}
