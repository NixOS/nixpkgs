{
  fetchFromGitHub,
  lib,
  php,
  php85,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "sculpin4";
  version = "4.0.0-alpha4";

  src = fetchFromGitHub {
    owner = "sculpin";
    repo = "sculpin";
    tag = version;
    hash = "sha256-I6n9D2vTSLYKbtXV5XvGC4n0AAEmVyvJPTq62IFcUYg=";
  };

  php = php85;

  vendorHash = "sha256-V+dL22TYv6YR17Lt/0Vq0V5HslEjTXTZMSh+aKx1tsY=";

  meta = {
    description = "PHP static site generator";
    license = lib.licenses.mit;
    homepage = "https://github.com/sculpin/sculpin";
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "sculpin";
  };
}
