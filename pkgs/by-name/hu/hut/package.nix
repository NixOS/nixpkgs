{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
}:

buildGoModule (finalAttrs: {
  pname = "hut";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~xenrox";
    repo = "hut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pc6E3ORDmaMhoNe8GQeYZrxhe5ySQqsMPe/iUbclnGk=";
  };

  vendorHash = "sha256-/51cv/EvcBCyCOf91vJ5M75p0bkAQqVoRUp+C+i70Os=";

  nativeBuildInputs = [
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  ldflags = [
    # Recommended in 0.7.0 release notes https://git.sr.ht/~xenrox/hut/refs/v0.7.0
    "-X main.version=v${finalAttrs.version}"
  ];

  postBuild = ''
    make $makeFlags completions doc/hut.1
  '';

  preInstall = ''
    make $makeFlags install
  '';

  meta = {
    homepage = "https://sr.ht/~xenrox/hut/";
    description = "CLI tool for Sourcehut / sr.ht";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "hut";
  };
})
