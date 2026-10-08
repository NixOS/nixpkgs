{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-WoLqLe6UGzlDTRNpB75O2CT31EZkpHQZ6vPQIK/K/8Q=";
  };

  vendorHash = "sha256-y2W4GZNC7atxHkboNVWd2CWPDqWU2XIyWGC5Q47QqQs=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
