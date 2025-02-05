{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.35.6";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-oTiADsEck/TZpXlC7/HEBSyd68QAjUq76AGeawIPhS0=";
  };

  vendorHash = "sha256-wIlntsf3PaRLWYZiI17ZdXidBV7LwAZdibUIX8yqATo=";

  ldflags = [ "-X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=${version}" ];

  postInstall = ''
    ln -s $out/bin/phrase-cli $out/bin/phrase
  '';

  meta = with lib; {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    changelog = "https://github.com/phrase/phrase-cli/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
  };
}
