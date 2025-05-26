{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bearer,
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    tag = "v${version}";
    hash = "sha256-mIjIcJzu3BatV4OQ18yHvwuUjS+zJHe4EFPYEFUwCjo=";
  };

  vendorHash = "sha256-+2iiMb2+/a3GCUMVA9boJJxuFgB3NmxpTePyMEA46jw=";

  subPackages = [ "cmd/bearer" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bearer/bearer/cmd/bearer/build.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = bearer;
      command = "bearer version";
    };
  };

  meta = with lib; {
    description = "Code security scanning tool (SAST) to discover, filter and prioritize security and privacy risks";
    homepage = "https://github.com/bearer/bearer";
    changelog = "https://github.com/Bearer/bearer/releases/tag/v${version}";
    license = with licenses; [ elastic20 ];
    maintainers = with maintainers; [ fab ];
  };
}
