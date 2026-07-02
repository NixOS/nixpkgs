{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
}:

buildGoModule (finalAttrs: {
  pname = "hut";
  version = "0.8.0";

  src = fetchFromSourcehut {
    owner = "~xenrox";
    repo = "hut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dbFqc+zlUihf/gz4Oo3LtbOClDDDB/khlCbI9/UgD2E=";
  };

  vendorHash = "sha256-7N+Zn7tzEG3dGeqNWmY98XUUKV7Y6g8wFZcQP9wea/8=";

  nativeBuildInputs = [
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  ldflags = [
    # Recommended in 0.8.0 release notes https://git.sr.ht/~xenrox/hut/refs/v0.8.0
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
