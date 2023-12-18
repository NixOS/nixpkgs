{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
}:

buildGoModule rec {
  pname = "hut";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-9RSJ+SRXYBjdiuHScgFm5i0/Xi81pJfURPKAGCk+l04=";
  };

  vendorHash = "sha256-OxnplvBx2sFctdNSVd0S0tgiRt5Yah3ga4mORT2Kz6U=";

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
    mainProgram = "hut";
  };
}
