{ lib, fetchpatch, fetchFromGitHub, buildPythonApplication, aiohttp, nest-asyncio, python-dateutil, humanize, click, pytestCheckHook, tox }:

buildPythonApplication rec {
  pname = "twtxt";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "buckket";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AdM95G2Vz3UbVPI7fs8/D78BMxscbTGrCpIyyHzSmho=";
  };

  patches = [
    (fetchpatch { # buckket/twtxt#165
      url = "https://github.com/buckket/twtxt/commit/9f58c95ac8bc313ff0e074cd886467ed3debfd1c.patch";
      sha256 = "sha256-WNU1hYBJ5oE2RL/u17Z78KA6KZkVkXC8rjc5BzRijbE=";
    })
    (fetchpatch { # buckket/twtxt#167
      url = "https://github.com/buckket/twtxt/commit/be1d5e906f3c788356e8e288bf66b05d2e2e2b03.patch";
      sha256 = "sha256-mWUHqGE97BvldY34gQWUK+GMcAEFLEqdvPEeeucqX4M=";
    })
  ];

  # Relax some dependencies
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'aiohttp>=2.2.5,<3' 'aiohttp' \
      --replace 'click>=6.7,<7' 'click' \
      --replace 'humanize>=0.5.1,<1' 'humanize'
  '';

  propagatedBuildInputs = [ aiohttp python-dateutil nest-asyncio humanize click ];

  checkInputs = [ pytestCheckHook tox ];

  disabledTests = [
     # Disable test using relative date and time
     "test_tweet_relative_datetime"
  ];

  meta = with lib; {
    description = "Decentralised, minimalist microblogging service for hackers";
    homepage = "https://github.com/buckket/twtxt";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
