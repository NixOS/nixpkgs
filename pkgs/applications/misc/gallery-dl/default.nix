{ lib, buildPythonApplication, fetchPypi, fetchpatch, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery-dl";
  version = "1.26.9";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "gallery_dl";
    sha256 = "sha256-PgbfppyJCpgFupBQng8MUPihbDmit4C+xWnSzCJyu5k=";
  };

  patches = [
    # catch general Exceptions. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/mikf/gallery-dl/commit/5227bb6b1d62ecef5b281592b0d001e7f9c101e3.patch";
      hash = "sha256-rVsd764siP/07XBPVDnpxMm/4kLiH3fp9+NtpHHH23U=";
    })
  ];

  propagatedBuildInputs = [
    requests
    yt-dlp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"

    # incompatible with pytestCheckHook
    "--ignore=test/test_ytdl.py"
  ];

  pythonImportsCheck = [
    "gallery_dl"
  ];

  meta = with lib; {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    mainProgram = "gallery-dl";
    maintainers = with maintainers; [ dawidsowa ];
  };
}
