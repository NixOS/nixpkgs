{ lib
, buildPythonApplication
, fetchFromGitHub
, click
, piexif
, pyicloud
, python-dateutil
, requests
, schema
, tqdm
, pytestCheckHook
, vcrpy
, mock
, freezegun
}:

buildPythonApplication rec {
  pname = "icloudpd";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "icloud-photos-downloader";
    repo = "icloud_photos_downloader";
    rev = "v${version}";
    sha256 = "aRF8M3w39CNjEvFGX3PgKQq3PxLUCLcVz+H/Q/t0YKk=";
  };

  propagatedBuildInputs = [
    click
    piexif
    pyicloud
    python-dateutil
    requests
    schema
    tqdm
  ];

  checkInputs = [
    pytestCheckHook
    vcrpy
    mock
    freezegun
  ];

  postPatch = ''
    # Unpin dependencies.
    # Also unfork pyicloud https://github.com/icloud-photos-downloader/icloud_photos_downloader/issues/179
    substituteInPlace requirements.txt \
      --replace 'pyicloud_ipd==' 'pyicloud>=' \
      --replace 'click==' 'click>=' \
      --replace 'python_dateutil==' 'python_dateutil>=' \
      --replace 'schema==' 'schema>=' \
      --replace 'tqdm==' 'tqdm>='

    # Use non-forked version.
    sed -i 's/pyicloud_ipd/pyicloud/g' $(grep -lr pyicloud_ipd)

    # Update API to classes renamed in 0.9.4
    # https://github.com/picklepete/pyicloud/releases/tag/0.9.4
    sed -i 's/PyiCloudAPIResponseError/PyiCloudAPIResponseException/g' $(grep -lr PyiCloudAPIResponseError)
    sed -i 's/NoStoredPasswordAvailable/PyiCloudNoStoredPasswordAvailableException/g' $(grep -lr NoStoredPasswordAvailable)
  '';

  preCheck = ''
    # Tests try to create ~/.pyicloud
    export HOME="$(mktemp -d)"
  '';

  # Too broken.
  doCheck = false;

  meta = with lib; {
    description = "Command-line tool to download photos and videos from iCloud";
    homepage = "https://github.com/icloud-photos-downloader/icloud_photos_downloader";
    changelog = "https://github.com/icloud-photos-downloader/icloud_photos_downloader/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
