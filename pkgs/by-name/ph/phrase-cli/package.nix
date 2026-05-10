{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "phrase-cli";
  version = "2.62.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-p8ixUGMA1S5TcFDocQ+mm35On+ZUUQRO8OZeXfzox20=";
  };

  vendorHash = "sha256-O16CdRqj3NevIunBfgIMJOkW1avE2wyeN1kJG6Wehco=";

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
