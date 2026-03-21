{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dblab";
  version = "0.34.3";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mK5DpFD1FgKmZscqJGHy+HY+GlYm2a6UgPFJHhjwtnU=";
  };

  vendorHash = "sha256-NhBT0dBS3jKgWHxCMVV6NUMcvqCbKS+tlm3y1YI/sAE=";

  ldflags = [ "-s -w -X main.version=${finalAttrs.version}" ];

  # some tests require network access
  doCheck = false;

  meta = {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
