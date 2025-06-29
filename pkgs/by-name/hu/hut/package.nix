{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
}:

buildGoModule rec {
  pname = "hut";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~xenrox";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-pc6E3ORDmaMhoNe8GQeYZrxhe5ySQqsMPe/iUbclnGk=";
  };

  vendorHash = "sha256-/51cv/EvcBCyCOf91vJ5M75p0bkAQqVoRUp+C+i70Os=";

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
    homepage = "https://sr.ht/~xenrox/hut/";
    description = "CLI tool for Sourcehut / sr.ht";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "hut";
  };
}
