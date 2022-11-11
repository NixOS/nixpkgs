{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
}:

buildGoModule rec {
  pname = "hut";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-g9KbOtZaBAgy/iBBh/Tv5ULJNnNzwzZpA6DOynl+dnk=";
  };

  vendorSha256 = "sha256-vuAx8B34Za+GEtekFOUaY07hBk3O2OaJ1JmulbIhwbs=";

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
