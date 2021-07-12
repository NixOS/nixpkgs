{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfswitch";
  version = "0.12.1119";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = version;
    sha256 = "1xsmr4hnmdg2il3rp39cyhv55ha4qcilcsr00iiija3bzxsm4rya";
  };

  vendorSha256 = "0mpm4m07v8w02g95cnj73m5gvd118id4ag2pym8d9r2svkyz5n70";

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  runVend = true;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

  meta = with lib; {
    description = "A command line tool to switch between different versions of terraform";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
