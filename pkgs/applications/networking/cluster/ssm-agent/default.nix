{ stdenv, fetchFromGitHub, buildGoPackage, bash, makeWrapper }:

buildGoPackage rec {
  pname   = "amazon-ssm-agent";
  version = "2.3.1319.0";

  goPackagePath = "github.com/aws/${pname}";
  subPackages   = [
    "agent"
    "agent/framework/processor/executer/outofproc/worker"
    "agent/framework/processor/executer/outofproc/worker"
    "agent/framework/processor/executer/outofproc/sessionworker"
    "agent/session/logging"
    "agent/cli-main"
  ];

  buildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    rev    = version;
    owner  = "aws";
    repo   = pname;
    sha256 = "1yiyhj7ckqa32b1rnbwn7zx89rsj00m5imn1xlpsw002ywxsxbnv";
  };

  preBuild = ''
    mv go/src/${goPackagePath}/vendor strange-vendor
    mv strange-vendor/src go/src/${goPackagePath}/vendor

    cd go/src/${goPackagePath}
    echo ${version} > VERSION

    substituteInPlace agent/plugins/inventory/gatherers/application/dataProvider.go \
      --replace '"github.com/aws/amazon-ssm-agent/agent/plugins/configurepackage/localpackages"' ""

    go run agent/version/versiongenerator/version-gen.go
    substituteInPlace agent/appconfig/constants_unix.go \
      --replace /usr/bin/ssm-document-worker $bin/bin/ssm-document-worker \
      --replace /usr/bin/ssm-session-worker $bin/bin/ssm-session-worker \
      --replace /usr/bin/ssm-session-logger $bin/bin/ssm-session-logger
    cd -
  '';

  postBuild = ''
    mv go/bin/agent go/bin/amazon-ssm-agent
    mv go/bin/worker go/bin/ssm-document-worker
    mv go/bin/sessionworker go/bin/ssm-session-worker
    mv go/bin/logging go/bin/ssm-session-logger
    mv go/bin/cli-main go/bin/ssm-cli
  '';

  postInstall = ''
    wrapProgram $out/bin/amazon-ssm-agent --prefix PATH : ${bash}/bin
  '';

  meta = with stdenv.lib; {
    description = "Agent to enable remote management of your Amazon EC2 instance configuration";
    homepage    = "https://github.com/aws/amazon-ssm-agent";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin manveru ];
  };
}
