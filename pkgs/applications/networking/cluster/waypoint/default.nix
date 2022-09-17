{ lib, buildGoModule, fetchFromGitHub, go-bindata, installShellFiles }:

buildGoModule rec {
  pname = "waypoint";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wvbtiu4WeuiHtyLkhwAB20XvpvHvy24xPSH5Lxtpea8=";
  };

  vendorSha256 = "sha256-bDsmou4zmRz8DyENdteJ3MzhTpCgri4ISIgxi7fhQdc=";

  nativeBuildInputs = [ go-bindata installShellFiles ];

  # GIT_{COMMIT,DIRTY} filled in blank to prevent trying to run git and ending up blank anyway
  buildPhase = ''
    runHook preBuild
    make bin GIT_DESCRIBE="v${version}" GIT_COMMIT="" GIT_DIRTY=""
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    local INSTALL="$out/bin/waypoint"
    install -D waypoint $out/bin/waypoint

    # waypoint's completion install command alters your <something>rc files
    # below is the equivalent of what it injects

    # Write to a file as it doesn't like EOF within <()
    cat > waypoint.fish <<EOF
    function __complete_waypoint
      set -lx COMP_LINE (commandline -cp)
      test -z (commandline -ct)
      and set COMP_LINE "$COMP_LINE "
      $INSTALL
    end
    complete -f -c waypoint -a "(__complete_waypoint)"
    EOF
    installShellCompletion --cmd waypoint \
      --bash <(echo "complete -C $INSTALL waypoint") \
      --fish <(cat waypoint.fish) \
      --zsh <(echo "complete -o nospace -C $INSTALL waypoint")

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # `version` tries to write to ~/.config/waypoint
    export HOME="$TMPDIR"

    $out/bin/waypoint --help
    $out/bin/waypoint version | grep "CLI: v${version}"
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
    maintainers = with maintainers; [ winpat jk techknowlogick ];
  };
}
