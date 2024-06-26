{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = version;
    sha256 = "sha256-Gp7+TEE7rmlabZhley/crpYZiqiKcc6uqSr6leZsmgU=";
  };

  vendorHash = "sha256-DsC9djgt7Er2m2TacUldpJP43jC0IBklPnu41Saf4DY=";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = with lib; {
    description = "A command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
