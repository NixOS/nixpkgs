{
  fetchFromGitHub,
  lib,
  php,
  php85,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin4";
  version = "4.0.0-alpha2";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-2ZyV889Sk0xrBjjPUtVS06kDSN+AgLz+dqFDKk3hEH0=";
  };

  php = php85;

  vendorHash = "sha256-WbvXS5ZJg9V0UGglkMiOS5pnztDE3gUxpkflMpSUbi4=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
