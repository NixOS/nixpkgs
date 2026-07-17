{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "github-commenter";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = "github-commenter";
    rev = finalAttrs.version;
    hash = "sha256-ZQEiDY+gOnUMxolgreDWkm9Uuc72WxcysAkT5DK/XLc=";
  };

  vendorHash = "sha256-DS2cTYQasIKmyqHS3kTpNMA4fuLxSv4n7ZQjeRWE0gI=";

  meta = {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    mainProgram = "github-commenter";
    license = lib.licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ lib.maintainers.mmahut ];
  };
})
