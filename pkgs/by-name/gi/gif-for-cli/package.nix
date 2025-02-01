{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  ffmpeg,
  zlib,
  libjpeg,
}:

python3Packages.buildPythonApplication {
  pname = "gif-for-cli";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gif-for-cli";
    rev = "31f8aa2d617d6d6e941154f60e287c38dd9a74d5";
    hash = "sha256-Bl5o492BUAn1KsscnlMIXCzJuy7xWUsdnxIKZKaRM3M=";
  };

  patches = [
    # https://github.com/google/gif-for-cli/pull/36
    (fetchpatch {
      name = "pillow-10-compatibility.patch";
      url = "https://github.com/google/gif-for-cli/commit/49b13ec981e197cbc10f920b7b25a97c4cc6a61c.patch";
      hash = "sha256-B8wfkdhSUY++St6DzgaJ1xF1mZKvi8oxLXbo63yemDM=";
    })
  ];

  # coverage is not needed to build and test this package
  postPatch = ''
    sed -i '/coverage>=/d' setup.py
  '';

  buildInputs = [
    zlib
    libjpeg
  ];

  propagatedBuildInputs = with python3Packages; [
    ffmpeg
    pillow
    requests
    x256
  ];

  meta = with lib; {
    description = "Render gifs as ASCII art in your cli";
    longDescription = "Takes in a GIF, short video, or a query to the Tenor GIF API and converts it to animated ASCII art.";
    homepage = "https://github.com/google/gif-for-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
    mainProgram = "gif-for-cli";
  };
}
