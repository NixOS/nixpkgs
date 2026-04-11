{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.12";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-u7TIhOGXfvWdAXvpL5qa43jaoa7PNAVL2MtGEuWBDPc=";
  };
  vendorHash = "sha256-7RoPv4OvOhiv+TmYOJuW95h/uh2LuTrpUSAZiTvbh7g=";
  pnpmDepsHash = "sha256-Ck2nqFwDv3OxN0ONA3A+h4Rli1te+EYqKivcqrAInKw=";
}
