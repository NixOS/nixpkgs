{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles }:

buildGoModule rec {
  pname = "age";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    hash = "sha256-O0NKDPvr+6ZupakPIpnGgDcdfG3nWR1pvVE+3KkYurY=";
  };

  vendorHash = "sha256-5We4OYoexzzSF1AkxuGCUwuYJ3Wra+T6mCcT4XYgzhU=";

  ldflags = [
    "-s" "-w" "-X main.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  # plugin test is flaky, see https://github.com/FiloSottile/age/issues/517
  checkFlags = [
    "-skip" "TestScript/plugin"
  ];

  meta = with lib; {
    changelog = "https://github.com/FiloSottile/age/releases/tag/v${version}";
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    mainProgram = "age";
    maintainers = with maintainers; [ tazjin ];
  };
}
