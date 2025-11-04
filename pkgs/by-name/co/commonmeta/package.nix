{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "commonmeta";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "front-matter";
    repo = "commonmeta";
    rev = "v${finalAttrs.version}";
    hash = "sha256-solx6gVY77FoMMeSv7Sf3ccSIhhTMRjSH/PnDbVNavk=";
  };

  vendorHash = "sha256-gzEnypW5VD9q3v+1zbI55e2mNIwz4mA0M9W6oh1SX5Y=";

  # The project is pure Go
  env.CGO_ENABLED = 0;

  # Many tests require access to external APIs (crossref.org, datacite.org, etc.)
  doCheck = false;

  meta = {
    description = "Go library and CLI for converting scholarly metadata";
    longDescription = ''
      commonmeta is a Go library to implement Commonmeta, the common Metadata Model for Scholarly Metadata. Use commonmeta to convert scholarly metadata in a variety of formats.
    '';
    homepage = "https://github.com/front-matter/commonmeta";
    changelog = "https://github.com/front-matter/commonmeta/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryangibb ];
    mainProgram = "commonmeta";
  };
})
