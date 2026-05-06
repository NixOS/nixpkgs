{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XvUSt6YV7TTFy2ZOatP42kSi5oK5LcdNkLJ94ozNfBk=";
  };

  vendorHash = "sha256-2z0V0nllbfiDflK7icM6poZw49oBX2/BTwxG92qACh4=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
})
