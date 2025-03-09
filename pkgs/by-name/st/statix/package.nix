{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bMs3XMiGP6sXCqdjna4xoV6CANOIWuISSzCaL5LYY4c=";
  };

  cargoHash = "sha256-QF7P0CWlKfBzVQC//eKhf/u1qV9AfLIJDxWDDWzMG8g=";

  buildFeatures = lib.optional withJson "json";

  # tests are failing on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    mainProgram = "statix";
    maintainers = with maintainers; [
      figsoda
      nerdypepper
    ];
  };
}
