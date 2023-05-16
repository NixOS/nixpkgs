<<<<<<< HEAD
{ lib, fetchFromGitHub, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.38.1";
=======
{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.36.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "ihabunek";
    repo   = "toot";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-gT9xKFanQhptt46nkdzYsZ6Vu0Nab0oRsvEHVRNf8DQ=";
=======
    sha256 = "sha256-gEQA9PASSKAMqulOaK8ynBXX7BdptY1uwdS1tOf3/Jc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages;
<<<<<<< HEAD
    [ requests beautifulsoup4 future wcwidth urwid psycopg2 tomlkit ];
=======
    [ requests beautifulsoup4 future wcwidth urwid psycopg2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    py.test
  '';

<<<<<<< HEAD
  passthru.tests.toot = nixosTests.pleroma;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Mastodon CLI interface";
    homepage    = "https://github.com/ihabunek/toot";
    license     = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}

