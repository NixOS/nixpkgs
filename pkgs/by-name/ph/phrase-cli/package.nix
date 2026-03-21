{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "phrase-cli";
  version = "2.56.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-i3MxJTj3FphsYfkGyIIxhuBzRdSIlfah5KyNxf0vUQE=";
  };

  vendorHash = "sha256-XJUADIbeCzbIRaPnbVeGIPImcPe3xdtBNxiAFhclWfE=";

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
