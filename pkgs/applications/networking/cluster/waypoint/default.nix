{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "waypoint";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lB9ELa/okNvtKFDP/vImEdYFJCKRgtAcpBG1kIoAysE=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-VxKUYD92DssoSjWxR+1gZLq34vCVM/4U2ju5felLWzI=";

  nativeBuildInputs = [ go-bindata ];

  # GIT_{COMMIT,DIRTY} filled in blank to prevent trying to run git and ending up blank anyway
  buildPhase = ''
    runHook preBuild
    make bin GIT_DESCRIBE="v${version}" GIT_COMMIT="" GIT_DIRTY=""
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D waypoint $out/bin/waypoint
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # `version` tries to write to ~/.config/waypoint
    export HOME="$TMPDIR"

    $out/bin/waypoint --help
    $out/bin/waypoint version | grep "Waypoint v${version}"
    runHook postInstallCheck
  '';

  # Binary is static
  dontPatchELF = true;
  dontPatchShebangs = true;

  meta = with lib; {
    homepage = "https://waypointproject.io";
    changelog = "https://github.com/hashicorp/waypoint/blob/v${version}/CHANGELOG.md";
    description = "A tool to build, deploy, and release any application on any platform";
    longDescription = ''
      Waypoint allows developers to define their application build, deploy, and
      release lifecycle as code, reducing the time to deliver deployments
      through a consistent and repeatable workflow.
    '';
    license = licenses.mpl20;
    maintainers = with maintainers; [ winpat jk ];
    platforms = platforms.linux;
  };
}
