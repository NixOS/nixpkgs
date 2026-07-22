{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "phrase-cli";
  version = "2.65.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-9GFprrLcae/uiQCi2PolLAUP89nCa02DZ3tEXUyXvhw=";
  };

  vendorHash = "sha256-vlssNVS1zTjYdp63NrR2rWOan5ng6t2BYEXv4L9q8Gc=";

  ldflags = [ "-X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=${finalAttrs.version}" ];

  postInstall = ''
    ln -s $out/bin/phrase-cli $out/bin/phrase
  '';

  meta = {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    changelog = "https://github.com/phrase/phrase-cli/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juboba ];
  };
})
