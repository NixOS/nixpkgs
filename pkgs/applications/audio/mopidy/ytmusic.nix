{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YTMusic";
    sha256 = "sha256-BZtW+qHsTnOMj+jdAFI8ZMwGxJc9lNosgPJZGbt4JgU=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.ytmusicapi
    python3Packages.pytube
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'ytmusicapi>=0.19.1,<0.20.0' 'ytmusicapi>=0.19.1'
  '';

  doCheck = true;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube Music";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
