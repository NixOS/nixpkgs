{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libevdev,
  openssl,
  makeWrapper,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "rkvm";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "htrefil";
    repo = "rkvm";
    rev = version;
    hash = "sha256-pGCoNmGOeV7ND4kcRjlJZbEMnmKQhlCtyjMoWIwVZrM=";
  };

  cargoHash = "sha256-2vioqALLeLFFmdZPwdTXCWJJkpQMWdi7KQ7mxO0Sviw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
  ];
  buildInputs = [ libevdev ];

  postInstall = ''
    install -Dm444 -t "$out/lib/systemd/system" systemd/rkvm-*.service
    install -Dm444 example/server.toml "$out/etc/rkvm/server.example.toml"
    install -Dm444 example/client.toml "$out/etc/rkvm/client.example.toml"

    wrapProgram $out/bin/rkvm-certificate-gen --prefix PATH : ${lib.makeBinPath [ openssl ]}
  '';

  passthru.tests = {
    inherit (nixosTests) rkvm;
  };

  meta = {
    description = "Virtual KVM switch for Linux machines";
    homepage = "https://github.com/htrefil/rkvm";
    changelog = "https://github.com/htrefil/rkvm/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
