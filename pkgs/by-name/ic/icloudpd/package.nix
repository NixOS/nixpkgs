{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  testers,
  icloudpd,
}:

python3Packages.buildPythonApplication rec {
  pname = "icloudpd";
  version = "1.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    tag = "v${version}";
    hash = "sha256-GZhc5AeOxfSPxloN630lQguh63ha63Wnuh0H6pMkPyE=";
  };

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    certifi
    click
    flask
    keyring
    keyrings-alt
    piexif
    python-dateutil
    pytz
    requests
    schema
    six
    srp
    tqdm
    typing-extensions
    tzlocal
    urllib3
    waitress
    wheel
  ];

  build-system = with python3Packages; [ setuptools ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    mock
    pytest-timeout
    pytestCheckHook
    vcrpy
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
    "test_folder_structure_de_posix"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = icloudpd; };
  };

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "wheel==0.45.1" "wheel"

    substituteInPlace src/foundation/__init__.py \
      --replace-fail "0.0.1" "${version}"
  '';

  meta = with lib; {
    homepage = "https://github.com/icloud-photos-downloader/icloud_photos_downloader";
    description = "iCloud Photos Downloader";
    license = licenses.mit;
    mainProgram = "icloudpd";
    maintainers = with maintainers; [
      anpin
    ];
  };
}
