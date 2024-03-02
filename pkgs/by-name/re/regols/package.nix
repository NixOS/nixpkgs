{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "regols";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kitagry";
    repo = "regols";
    rev = "v${version}";
    hash = "sha256-2ZwmIlv3kJ26p15t7NvB9sX2GO+B3ypeNl50b7XA0Iw=";
  };

  vendorHash = "sha256-N6gtkZSNLXz3B961grM3xHzm7x4/kzcLkDOgiFLGp8U=";

  meta = with lib; {
    description = "OPA Rego language server";
    homepage = "https://github.com/kitagry/regols";
    license = licenses.mit;
    maintainers = with maintainers; [ alias-dev ];
  };
}
