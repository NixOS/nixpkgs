{ stdenv, fetchFromGitHub, glibcLocales, pandoc, python3 }:

let
  pythonPackages = python3.pkgs;

in pythonPackages.buildPythonApplication rec {
  name = "coursera-dl-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "coursera-dl";
    repo = "coursera-dl";
    rev = version;
    sha256 = "0m3f6ly8c3mkb8yy2y398afswqgy17rz159s1054wzxpb4f85zlb";
  };

  nativeBuildInputs = with pythonPackages; [ pandoc ];

  buildInputs = with pythonPackages; [ glibcLocales ];

  propagatedBuildInputs = with pythonPackages; [ beautifulsoup4 ConfigArgParse keyring pyasn1 requests six urllib3 ];

  checkInputs = with pythonPackages; [ pytest mock ];

  preConfigure = ''
    export LC_ALL=en_US.utf-8
  '';

  checkPhase = ''
    # requires dbus service
    py.test -k 'not test_get_credentials_with_keyring' .
  '';

  meta = with stdenv.lib; {
    description = "CLI for downloading Coursera.org videos and naming them";
    homepage = https://github.com/coursera-dl/coursera-dl;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
