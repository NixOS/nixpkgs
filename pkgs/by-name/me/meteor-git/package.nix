{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "meteor-git";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "stefanlogue";
    repo = "meteor";
    rev = "v${version}";
    hash = "sha256-UA6bye9ti9AwnZkBIGjljDElkIEOhsiJ0NyYdKbF5m0=";
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
