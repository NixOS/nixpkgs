{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = "pipes-rs";
    rev = "v${version}";
    sha256 = "sha256-NrBmkA7sV1RhfG9KEqQNMR5s0l2u66b7KK0toDjQIps=";
  };

  cargoHash = "sha256-0up9S3+NjBV8zsvsyVANvITisMSBXsab6jFwt19gnQk=";

  doInstallCheck = true;

  installCheckPhase = ''
    if [[ "$("$out/bin/pipes-rs" --version)" == "pipes-rs ${version}" ]]; then
      echo 'pipes-rs smoke check passed'
    else
      echo 'pipes-rs smoke check failed'
      return 1
    fi
  '';

  meta = with lib; {
    description = "Over-engineered rewrite of pipes.sh in Rust";
    mainProgram = "pipes-rs";
    homepage = "https://github.com/lhvy/pipes-rs";
    license = licenses.blueOak100;
    maintainers = [ maintainers.vanilla ];
  };
}
