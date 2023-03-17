{ lib, fetchFromGitHub, fetchpatch, glibcLocales, pandoc, python3 }:

let
  pythonPackages = python3.pkgs;

in pythonPackages.buildPythonApplication rec {
  pname = "coursera-dl";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "coursera-dl";
    repo = "coursera-dl";
    rev = version;
    sha256 = "0akgwzrsx094jj30n4bd2ilwgva4qxx38v3bgm69iqfxi8c2bqbk";
  };

  nativeBuildInputs = with pythonPackages; [ pandoc ];

  buildInputs = with pythonPackages; [ glibcLocales ];

  propagatedBuildInputs = with pythonPackages; [ attrs beautifulsoup4 configargparse keyring pyasn1 requests six urllib3 ];

  nativeCheckInputs = with pythonPackages; [ pytest mock ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace '==' '>='
  '';

  preConfigure = ''
    export LC_ALL=en_US.utf-8
  '';

  checkPhase = ''
    # requires dbus service
    py.test -k 'not test_get_credentials_with_keyring' .
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/c8796e567698be166cb15f54e095140c1a9b567e.patch";
      sha256 = "sha256:07ca6zdyw3ypv7yzfv2kzmjvv86h0rwzllcg0zky27qppqz917bv";
    })
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/6c221706ba828285ca7a30a08708e63e3891b36f.patch";
      sha256 = "sha256-/AKFvBPInSq/lsz+G0jVSl/ukVgCnt66oePAb+66AjI=";
    })
  ];

  meta = with lib; {
    description = "CLI for downloading Coursera.org videos and naming them";
    homepage = "https://github.com/coursera-dl/coursera-dl";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
