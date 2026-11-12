{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-r7dCw8C5ia5TzMajfdBQ15yBXh+jbBPViSQQknuH+Qs=";
  };

  vendorHash = "sha256-mUtZbSwqywbdIe2J3VksqV3az8WJSMDv2nMNZQL+y08=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
