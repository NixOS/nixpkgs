{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certigo";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certigo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y2m+uO/jxwWdutry859Y6IdNJpXjjkrlJ+LJrjS616Y=";
  };

  vendorHash = "sha256-u10YSa2xFswJk/2iC7eyfQ51oTaa30/6JA5aLk5021k=";

  meta = {
    description = "Utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    changelog = "https://github.com/square/certigo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "certigo";
  };
})
