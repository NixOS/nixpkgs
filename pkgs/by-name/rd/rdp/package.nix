{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rdp";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urschrei";
    repo = "rdp";
    rev = "refs/tags/v${version}";
    hash = "sha256-DqkifIzctC/f6as/X/+njb2aCFmf4yB1Nj/LMh2IQSY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    chmod +w Cargo.lock # refuse to compile with permission error if unset
  '';

  postInstall = ''
    mkdir -p $out/include

    install -Dm644 include/header.h -t $out/include
  '';

  meta = {
    description = "Provide FFI access to fast Ramer–Douglas–Peucker and Visvalingam-Whyatt line simplification algorithms";
    homepage = "https://docs.rs/rdp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
