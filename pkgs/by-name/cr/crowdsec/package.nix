{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "crowdsec";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = "crowdsec";
    tag = "v${version}";
    hash = "sha256-ILGvHSDONyq6O1V/xm4lanSTmkdkMAwvvhoUtM2b7Gc=";
  };

  vendorHash = "sha256-B9VZlNks7/ozay5+di++sbLwIKN98P7U+o6knVaKlqo=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/crowdsec"
    "cmd/crowdsec-cli"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crowdsecurity/go-cs-lib/version.Version=v${version}"
    "-X github.com/crowdsecurity/go-cs-lib/version.BuildDate=1970-01-01_00:00:00"
    "-X github.com/crowdsecurity/go-cs-lib/version.Tag=v${version}"
    "-X github.com/crowdsecurity/crowdsec/pkg/cwversion.Codename=alphaga"
    "-X github.com/crowdsecurity/crowdsec/pkg/csconfig.defaultConfigDir=/etc/crowdsec"
    "-X github.com/crowdsecurity/crowdsec/pkg/csconfig.defaultDataDir=/var/lib/crowdsec/data"
  ];

  postBuild = "mv $GOPATH/bin/{crowdsec-cli,cscli}";

  postInstall = ''
    mkdir -p $out/share/crowdsec
    cp -r ./config $out/share/crowdsec/

    mkdir -p $out/lib/systemd/system
    substitute ./config/crowdsec.service $out/lib/systemd/system/crowdsec.service \
      --replace-fail /usr/local $out

    installShellCompletion --cmd cscli \
      --bash <($out/bin/cscli completion bash) \
      --fish <($out/bin/cscli completion fish) \
      --zsh <($out/bin/cscli completion zsh)
  '';

  # It's important that the version is correctly set as it also determines feature capabilities
  preCheck = ''
    version=$($GOPATH/bin/cscli version 2>&1 | sed -nE 's/^version: (.*)/\1/p')

    if [ "$version" != "v${version}" ]; then
        echo "Invalid version string: '$version'"
        exit 1
    fi
  '';

  meta = {
    homepage = "https://crowdsec.net/";
    changelog = "https://github.com/crowdsecurity/crowdsec/releases/tag/v${version}";
    description = "Free, open-source and collaborative IPS";
    longDescription = ''
      CrowdSec is a free, modern & collaborative behavior detection engine,
      coupled with a global IP reputation network. It stacks on fail2ban's
      philosophy but is IPV6 compatible and 60x faster (Go vs Python), uses Grok
      patterns to parse logs and YAML scenario to identify behaviors. CrowdSec
      is engineered for modern Cloud/Containers/VM based infrastructures (by
      decoupling detection and remediation). Once detected you can remedy
      threats with various bouncers (firewall block, nginx http 403, Captchas,
      etc.) while the aggressive IP can be sent to CrowdSec for curation before
      being shared among all users to further improve everyone's security.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
      urandom
    ];
  };
}
