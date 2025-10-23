{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.48.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-X6Y7B9LLxoxsMbLlhJTlHWdnJV6ZG4EuV+Dww6mtgAc=";
  };

  vendorHash = "sha256-si1io4DMjhUhpAwb4ctUFLdIblZOBskn9dGwCTy4pAo=";

  ldflags = [ "-X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=${version}" ];

  postInstall = ''
    ln -s $out/bin/phrase-cli $out/bin/phrase
  '';

  meta = {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    changelog = "https://github.com/phrase/phrase-cli/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juboba ];
  };
}
