{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "phrase-cli";
  version = "2.58.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-AFmLtF5XngvJy6hXh0L6dW4dvzVjlf5mHI2MgS3DT+g=";
  };

  vendorHash = "sha256-TmtDxo724yesSN7hZ4xoLG92BTwhz/hc5voY4wL7DHI=";

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
