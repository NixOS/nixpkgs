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
  version = "1.32.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    tag = "v${version}";
    hash = "sha256-XwMY3OBGYDA/DKTXYgxuMV9pbamy8NbitMrEbsEmlMk=";
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
    "test_all_http_methods_covered"
    "test_builtin_timeout_error_handling"
    "test_connection_error_handling"
    "test_new_connection_error_handling"
    "test_normal_request"
    "test_other_exceptions_pass_through"
    "test_timeout_error_handling"
    "test_response_to_har_entry_with_large_streaming_response"
    "test_response_to_har_entry_with_real_json_response"
    "test_response_to_har_entry_with_real_streaming_response"
    "test_response_to_har_entry_with_real_text_response"
    "test_streaming_vs_non_streaming_behavior"
    # touches non-existing folders
    "test_folder_structure_de_posix"
    "test_missing_directory"
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

  meta = {
    homepage = "https://github.com/icloud-photos-downloader/icloud_photos_downloader";
    description = "iCloud Photos Downloader";
    license = lib.licenses.mit;
    mainProgram = "icloudpd";
    maintainers = with lib.maintainers; [
      anpin
    ];
  };
}
