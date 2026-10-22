{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "opsec";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Naiko8642";
    repo = "opsec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OWDdOk4VKWfpYgSYkdfghQbE+Z0AEOBjCfl0FsPIkcE=";
  };

  patches = [
    ./go-mod-tidy.patch
  ];

  vendorHash = "sha256-5NFjKo59hfV0Y+2pQ+1URJHrIZu6DsuABrA93Q3v7gY=";

  meta = {
    description = "opsec";
    mainProgram = "opsec";
    maintainers = [ lib.maintainers.naturalspottingsmite ];
  };
})
