{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {

  pname = "gotemplate";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = "gotemplate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O3tImosacomIQGAnbShCOWjwuvwo3HsXViVBSHj6Z6c=";
  };

  vendorHash = "sha256-gxKtwA9i9wYWYsBx7zSfKiTsADN8cC7tbWzoX2mctZM=";

  # This is the value reported when running `gotemplate --version`,
  # see https://github.com/coveooss/gotemplate/issues/262
  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  meta = {
    description = "CLI for go text/template";
    homepage = "https://github.com/coveooss/gotemplate";
    mainProgram = "gotemplate";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.giorgiga ];
  };

})
