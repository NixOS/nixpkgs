{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${version}";
    sha256 = "sha256-Ym0ypMfoceOvje1z1oCxjnFrl1oosMFSplM7bhI0KXU=";
  };

  vendorHash = "sha256-44A9fF+HIOJrlxpps6GV3yjPBqfpwOhEZ8Ejnp2o/wk=";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = with lib; {
    description =
      "A command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
