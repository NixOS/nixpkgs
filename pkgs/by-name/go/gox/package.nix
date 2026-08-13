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
    sha256 = "0mkh81hd7kn45dz7b6yhzqsg2mvg1g6pwx89jjigxrnqhyg9vrl7";
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
