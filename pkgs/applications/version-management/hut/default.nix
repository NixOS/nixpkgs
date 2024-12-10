{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
}:

buildGoModule rec {
  pname = "hut";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-Gkxe9B48nwHOlqkgjMdFLBy7OiR7cwDDE3qLvWxJK+Y=";
  };

  vendorHash = "sha256-OYXRQEP4ACkypXmrorf2ew18819DB38SsYOM0u0steg=";

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
