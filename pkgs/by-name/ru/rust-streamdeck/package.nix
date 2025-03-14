{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  lib,
  udev,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "rust-streamdeck";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ryankurte";
    repo = "rust-streamdeck";
    tag = "v${version}";
    hash = "sha256-9FuTnRQHKYJzMqhhgyTVq2R+drn4HAr3GDNjQgc3r+w=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${builtins.placeholder "out"}/bin/${meta.mainProgram}";

  postInstall = ''
    install -Dm444 40-streamdeck.rules -t $out/lib/udev/rules.d/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ibusb based driver for Elgato StreamDeck devices";
    homepage = "https://github.com/ryankurte/rust-streamdeck";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.gdifolco ];
    mainProgram = "streamdeck-cli";
  };
}
