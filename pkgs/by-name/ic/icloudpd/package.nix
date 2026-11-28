{
  lib,
  python314Packages,
  fetchFromGitHub,
  nix-update-script,
  testers,
  icloudpd,
}:

python314Packages.buildPythonApplication (finalAttrs: {
  pname = "icloudpd";
  version = "1.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rhX+8RdiwhnwSUEwXBOiABDv67t44PAIcYhlTVLd8Mw=";
  };

  pythonRelaxDeps = true;

  dependencies = with python314Packages; [
    certifi
    flask
    keyring
    keyrings-alt
    piexif
    pytz
    requests
    schema
    srp
    tqdm
    typing-extensions
    tzlocal
    urllib3
    waitress
    tzdata
    fido2
  ];

  build-system = with python314Packages; [ setuptools ];

  nativeCheckInputs = with python314Packages; [
    freezegun
    mock
    pytest-timeout
    pytestCheckHook
    vcrpy
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = icloudpd; };
  };

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.2.1" "setuptools" \
      --replace-fail "wheel==0.48.0" "wheel"

    substituteInPlace src/foundation/__init__.py \
      --replace-fail "0.0.1" "${finalAttrs.version}"
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
})
