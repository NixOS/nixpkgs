{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "waypoint";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JeuVrlm6JB8MgSUmgMLQPuPmlKSScSdsVga9jUwLWHM=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-ArebHOjP3zvpASVAoaPXpSbrG/jq+Jbx7+EaQ1uHSVY=";

  nativeBuildInputs = [ go-bindata ];

  # GIT_{COMMIT,DIRTY} filled in blank to prevent trying to run git and ending up blank anyway
  buildPhase = ''
    make bin GIT_DESCRIBE="v${version}" GIT_COMMIT="" GIT_DIRTY=""
  '';

  installPhase = ''
    install -D waypoint $out/bin/waypoint
  '';

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
