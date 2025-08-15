{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  udev,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "litra";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-rs";
    tag = "v${version}";
    hash = "sha256-inkY6nPeh//Vzp8HM0KQs82kTR4Z/snA0jZ1y2Rx/x8=";
  };

  cargoHash = "sha256-6iX1AsdpVwStkuIrXOg6ijNCftYPBKzHz7E0wB9HmZQ=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp *.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "Control your Logitech Litra light from the command line";
    homepage = "https://github.com/timrogers/litra-rs";
    license = lib.licenses.mit;
    mainProgram = "litra";
    maintainers = with lib.maintainers; [
      sh3rm4n
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
