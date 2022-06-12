{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfswitch";
  version = "0.13.1250";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = version;
    sha256 = "sha256-OfQUwAv7PgjcDLE4Wm6I8pAHeLV9sHlLHRVqTB13B4c=";
  };

  vendorSha256 = "sha256-jM9xYwBshBpaT4duBTvVwYUOapQfUbq9kL7EaRIGfQY=";

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
