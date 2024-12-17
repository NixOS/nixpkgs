{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
}:

buildGoModule rec {
  pname = "hut";
  version = "0.6.0";

  src = fetchFromSourcehut {
    owner = "~xenrox";
    repo = "hut";
    rev = "v${version}";
    sha256 = "sha256-wfnuGnO1aiK0D8P5nMCqD38DJ3RpcsK//02KaE5SkZE=";
  };

  vendorHash = "sha256-6dIqcjtacxlmadnPzRlOJYoyOaO4zdjzrjO64KS2Bq0=";

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
