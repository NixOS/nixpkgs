{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {

  pname = "beszel-agent";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    rev = "v${version}";
    hash = "sha256-IXVDpi8mtlk01BKIpH3a9yUZg/2ZfDa/JrPIIcgzO+E=";
  };

  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-5+/xzgVVQiooXmbJ+8WCCgUJKTQwJECEUcYt7qoEEJs=";

  ldflags = [ "-w -s" ];

  subPackages = [ "cmd/agent" ];

  postInstall = ''
    mv $out/bin/agent $out/bin/${meta.mainProgram}
  '';

  meta = {
    description = "Agent for the Beszel server monitoring system.";
    mainProgram = "beszel-agent";
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bot-wxt1221
      giorgiga
    ];
  };

}
