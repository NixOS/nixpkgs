{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = "onetun";
    rev = "v${version}";
    sha256 = "sha256-bggBBl2YQUncfOYIDsPgrHPwznCJQOlIOY3bbiZz7Rw=";
  };

  cargoHash = "sha256-VC7q2ZTdbBmvZ9l70uQz59paFIi8HXp5CPxfQC6cVmk=";

  meta = {
    description = "Cross-platform, user-space WireGuard port-forwarder that requires no root-access or system network configurations";
    homepage = "https://github.com/aramperes/onetun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "onetun";
  };
}
