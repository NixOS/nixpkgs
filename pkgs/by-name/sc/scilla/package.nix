{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scilla";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "scilla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-woL0NJU+Y+cFjNjTIPN7PsGZhIo7ynjeMnK5HqPj52g=";
  };

  vendorHash = "sha256-R5YFVjlCderN9lUKCk1FLs8JBXsYmGG9KvGeDYC2n0c=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];

  meta = {
    description = "Information gathering tool for DNS, ports and more";
    mainProgram = "scilla";
    homepage = "https://github.com/edoardottt/scilla";
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
