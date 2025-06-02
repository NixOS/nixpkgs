{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-dLdgJdR2faxpfHmYhhzn7nQxTrXDhF6XqOIKFLXDEj4=";
  };

  vendorHash = "sha256-zVIxBZ2zTXk407piA4dXxKfyD7Ke8RIq7lYogr/+rcs=";

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
