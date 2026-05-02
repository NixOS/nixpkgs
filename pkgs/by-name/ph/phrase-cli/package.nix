{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "phrase-cli";
  version = "2.61.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-VSkogD90hLgKw/3xXzfs4TktmoLf/RtfaJxEjk/uFsQ=";
  };

  vendorHash = "sha256-w3XJUE1iM+yi4cMqMTUDhiafV5v42v4zBJzckv3Fd70=";

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
