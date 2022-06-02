{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
}:

buildGoModule rec {
  pname = "hut";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-2YUrDPulpLQQGw31nEasHoQ/AppECg7acwwqu6JDT5U=";
  };

  vendorSha256 = "sha256-EmokL3JlyM6C5/NOarCAJuqNsDO2tgHwqQdv0rAk+Xk=";

  nativeBuildInputs = [
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postBuild = ''
    make $makeFlags completions doc/hut.1
  '';

  preInstall = ''
    make $makeFlags install
  '';

  meta = with lib; {
    homepage = "https://sr.ht/~emersion/hut/";
    description = "A CLI tool for Sourcehut / sr.ht";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
