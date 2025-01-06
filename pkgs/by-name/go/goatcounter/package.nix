{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  goatcounter,
  nixosTests,
}:

buildGoModule rec {
  pname = "goatcounter";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "goatcounter";
    rev = "v${version}";
    hash = "sha256-lwiLk/YYxX4QwSDjpU/mAikumGXYMzleRzmPjZGruZU=";
  };

  vendorHash = "sha256-YAb3uBWQc6hWzF1Z5cAg8RzJQSJV+6dkppfczKS832s=";
  subPackages = [ "cmd/goatcounter" ];
  modRoot = ".";

  # Derived from the upstream build scripts:
  #
  # `-trimpath` is used, which `allowGoReference` sets
  allowGoReference = true;
  # Flags set in the upstream build.
  ldflags = [
    "-s"
    "-w"
    "-X zgo.at/goatcounter/v2.Version=${src.rev}"
  ];

  passthru.tests = {
    moduleTest = nixosTests.goatcounter;
    version = testers.testVersion {
      package = goatcounter;
      command = "goatcounter version";
      version = "v${version}";
    };
  };

  meta = {
    description = "Easy web analytics. No tracking of personal data";
    changelog = "https://github.com/arp242/goatcounter/releases/tag/${src.rev}";
    longDescription = ''
      GoatCounter is an open source web analytics platform available as a hosted
      service (free for non-commercial use) or self-hosted app. It aims to offer easy
      to use and meaningful privacy-friendly web analytics as an alternative to
      Google Analytics or Matomo.
    '';
    homepage = "https://github.com/arp242/goatcounter";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ tylerjl ];
    mainProgram = "goatcounter";
  };
}
