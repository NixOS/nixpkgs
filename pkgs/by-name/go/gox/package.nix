{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  go,
}:

buildGoModule (finalAttrs: {
  pname = "gox";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "gox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h+adnofY5v6ilAl1fs0Lb1fxNP7Qm3V+K8TO02BAcFY=";
  };

  vendorHash = null;

  # This is required for wrapProgram.
  allowGoReference = true;

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/gox --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = {
    homepage = "https://github.com/mitchellh/gox";
    description = "Dead simple, no frills Go cross compile tool";
    mainProgram = "gox";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
})
