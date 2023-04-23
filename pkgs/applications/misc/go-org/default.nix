{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-org";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "niklasfasching";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wp8WEfRcrtn+VdcbehYcOJI5FkPQiyo6nLsTDvR7riE=";
  };

  vendorSha256 = "sha256-njx89Ims7GZql8sbVmH/E9gM/ONRWiPRLVs+FzsCSzI=";

  postInstallCheck = ''
    $out/bin/go-org > /dev/null
  '';

  meta = with lib; {
    description = "Org-mode parser and static site generator in go";
    homepage = "https://niklasfasching.github.io/go-org";
    license = licenses.mit;
    maintainers = with maintainers; [ payas ];
  };
}
