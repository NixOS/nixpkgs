{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "meteor-git";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "stefanlogue";
    repo = "meteor";
    rev = "v${version}";
    hash = "sha256-T4/SO6GW668w5bskfZbdAFBXiKIS9FXuMXOii8ZfOVc=";
  };

  vendorHash = "sha256-jKd/eJwp5SZvTrP3RN7xT7ibAB0PQondGR3RT+HQXIo=";

  meta = {
    description = "CLI tool for writing conventional commits";
    mainProgram = "meteor";
    homepage = "https://github.com/stefanlogue/meteor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nebunebu ];
  };
}
