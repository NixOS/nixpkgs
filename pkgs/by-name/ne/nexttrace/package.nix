{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "nexttrace";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wcS/HgErLkP3YhWeHujtjJU3c/5GrW0vl2IrnYuWAPs=";
  };

  vendorHash = "sha256-SRrWYyv8aDOBtGPSHat8umNArrIn+henPwb1l5JRN3s=";

  buildInputs = [ libpcap ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-X=github.com/nxtrace/NTrace-core/config.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/NTrace-core $out/bin/nexttrace
  '';

  doInstallCheck = true;

  meta = {
    description = "Open source visual route tracking CLI tool";
    homepage = "https://www.nxtrace.org/";
    changelog = "https://github.com/nxtrace/NTrace-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sharzy ];
    mainProgram = "nexttrace";
  };
})
