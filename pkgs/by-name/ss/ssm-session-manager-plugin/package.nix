{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "ssm-session-manager-plugin";
  version = "1.2.707.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "session-manager-plugin";
    rev = version;
    hash = "sha256-4DPwFKt5pNNl4AczgIhZA7CuBHx7q41jMZKenDFYmwg=";
  };

  patches = [
    # Add support for Go modules.
    #
    # This patch doesn't belong to any upstream PR, it is specially crafted for
    # nixpkgs. Deleting the vendor dir is left out from the patch and done in
    # postPatch instead, as otherwise the patch would be to big and GitHub returns
    # an error.
    #
    # With https://github.com/aws/session-manager-plugin/pull/74 there is an
    # upstream PR with the same goal. It isn't pulled here as patch for the same
    # reason.
    #
    # Notice that the dependencies are pinned with the patch, and upstream dependency
    # updates won't take effect. Patch should be recreated from time to time.
    # - `rm -rf vendor`
    # - `go mod init github.com/aws/session-manager-plugin`
    # - `go mod tidy`
    # - `go get github.com/twinj/uuid@v0.0.0-20151029044442-89173bcdda19`
    # - `go mod tidy`
    # - `git checkout HEAD vendor`
    ./0001-module-support.patch
  ];

  postPatch = ''
    rm -rf vendor
  '';

  vendorHash = "sha256-wK+aWRC5yrPtdihXAj6RlYC9ZTTPuGUg9wLY33skzeE=";

  subPackages = [ "src/sessionmanagerplugin-main" ];

  preBuild = ''
    echo -n ${lib.escapeShellArg version} > VERSION
    go run src/version/versiongenerator/version-gen.go
  '';

  doCheck = true;
  checkFlags = [ "-skip=TestSetSessionHandlers" ];

  # The AWS CLI is expecting the binary name to be 'session-manager-plugin' and
  # since the outfile is different the following workaround is renaming the binary.
  postBuild = ''
    mv $GOPATH/bin/sessionmanagerplugin-main $GOPATH/bin/${meta.mainProgram}
  '';

  preCheck = ''
    if ! [[ $($GOPATH/bin/${meta.mainProgram} --version) = ${lib.escapeShellArg version} ]]; then
      echo 'wrong version'
      exit 1
    fi
  '';

  meta = {
    homepage = "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    mainProgram = "session-manager-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      amarshall
      mbaillie
      ryan4yin
    ];
  };
}
