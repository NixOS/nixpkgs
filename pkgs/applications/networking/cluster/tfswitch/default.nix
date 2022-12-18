{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfswitch";
  version = "0.13.1300";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = version;
    sha256 = "sha256-btvoFllCfwQJNpRWdAB05Cu4JYmT1xynJxDbzO/6LDs=";
  };

  vendorSha256 = "sha256-NX+vzI/Fa/n9ZQjpESes4fNVAmKlA1rqPwSKsL2GEUY=";

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
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
