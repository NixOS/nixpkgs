{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
}:

buildGoModule rec {
  pname = "hut";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-kr5EWQ3zHUp/oNPZV2d3j9AyoEmHEX8/rETiMKTBi3s=";
  };

  vendorHash = "sha256-aoqGb7g8UEC/ydmL3GbWGy3HDD1kfDJOMeUP4nO9waA=";

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
