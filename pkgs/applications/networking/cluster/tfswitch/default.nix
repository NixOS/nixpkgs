{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfswitch";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = version;
    sha256 = "sha256-zUFnJCYh6XM0HiET45ZRa/ESS/n3XdYKkUJuLiDDRAg=";
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
    description =
      "A command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
