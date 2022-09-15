{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pYqaBLrGEZUhIqaoYhkXrf2OoaAfswQntSa8FnYMBLA=";
  };

  cargoSha256 = "sha256-ud6bhyWePINiddSuWcpUkMjp3q6/Xd9TK3CaoFZFB20=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
