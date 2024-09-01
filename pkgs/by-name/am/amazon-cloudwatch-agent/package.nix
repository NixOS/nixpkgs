{
  config,
  lib,
  buildGoModule,
  fetchgit,
  pkgs,
}:

buildGoModule rec {
  pname = "amazon-cloudwatch-agent";
  version = "1.300044.0";

  src = fetchgit {
    url = "https://github.com/aws/amazon-cloudwatch-agent.git";
    rev = "v${version}";
    sha256 = "sha256-sG0dvmTagpob23/5L2QB32bwFmmRygEQKrAmgAWgEOE=";
  };

  vendorHash = "sha256-a1xjnVXvSinYGqjFOmlCxJwWc9sc9OAfSuAMRCAlxCM=";

  meta = with lib; {
    description = "Amazon CloudWatch Agent";
    homepage = "https://github.com/aws/amazon-cloudwatch-agent";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ pmw ];
    # The agent supports MacOS and Windows, but it's not currently working for me on macOS:
    # > cannot execute binary file: Exec format error
    # so I am declaring support only for Linux where I tested it personally.
    platforms = with lib.platforms; linux;
  };

  doCheck = false;

  patchPhase = ''

    echo "" >> Makefile
    echo "amazon-cloudwatch-agent-nixos-linux: copy-version-file" >> Makefile
    echo -e "\t@echo Building CloudWatchAgent for Linux,Debian with ARM64 and AMD64" >> Makefile
    echo -e "\t\$(LINUX_AMD64_BUILD)/config-downloader github.com/aws/amazon-cloudwatch-agent/cmd/config-downloader" >> Makefile
    echo -e "\t\$(LINUX_AMD64_BUILD)/config-translator github.com/aws/amazon-cloudwatch-agent/cmd/config-translator" >> Makefile
    echo -e "\t\$(LINUX_AMD64_BUILD)/amazon-cloudwatch-agent github.com/aws/amazon-cloudwatch-agent/cmd/amazon-cloudwatch-agent" >> Makefile
    echo -e "\t\$(LINUX_AMD64_BUILD)/start-amazon-cloudwatch-agent github.com/aws/amazon-cloudwatch-agent/cmd/start-amazon-cloudwatch-agent" >> Makefile
    echo -e "\t\$(LINUX_AMD64_BUILD)/amazon-cloudwatch-agent-config-wizard github.com/aws/amazon-cloudwatch-agent/cmd/amazon-cloudwatch-agent-config-wizard" >> Makefile

  '';

  buildPhase = ''

    export FAKEBUILD="false"

    if [ $FAKEBUILD == "true" ]
    then
      mkdir -p build/bin/linux_amd64
      touch build/bin/linux_amd64/fakebin
    else
      make amazon-cloudwatch-agent-nixos-linux
    fi

  '';

  installPhase = ''

    runHook preInstall

    mkdir -p $out/etc

    cp -av build/bin/linux_amd64 $out/bin

    cp LICENSE $out/
    cp NOTICE $out/
    cp licensing/THIRD-PARTY-LICENSES $out/
    cp RELEASE_NOTES $out/
    cp packaging/dependencies/amazon-cloudwatch-agent-ctl $out/bin/

    # TODO in patchPhase

    mkdir -p /tmp/amazon-cloudwatch-agent
    touch /tmp/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log
    ln -s /tmp/amazon-cloudwatch-agent/log $out/log

    runHook postInstall
  '';
}
