{ stdenv, fetchFromGitHub, glibcLocales, pandoc, python3 }:

let
  pythonPackages = python3.pkgs;

in pythonPackages.buildPythonApplication rec {
  pname = "coursera-dl";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "coursera-dl";
    repo = "coursera-dl";
    rev = version;
    sha256 = "0dn7a6s98dwba62r0dyabq8pryzga4b2wpx88i9bmp7ja1b1f92f";
  };

  nativeBuildInputs = with pythonPackages; [ pandoc ];

  buildInputs = with pythonPackages; [ glibcLocales ];

  propagatedBuildInputs = with pythonPackages; [ attrs beautifulsoup4 ConfigArgParse keyring pyasn1 requests six urllib3 ];

  checkInputs = with pythonPackages; [ pytest mock ];

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

  meta = with stdenv.lib; {
    description = "CLI for downloading Coursera.org videos and naming them";
    homepage = https://github.com/coursera-dl/coursera-dl;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
