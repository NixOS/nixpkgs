{
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  lib,
  udev,
  udevCheckHook,
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

  cargoPatches = [
    (fetchpatch {
      name = "add_cargo_lock.patch";
      url = "https://github.com/ryankurte/rust-streamdeck/commit/d8497c34898daebafca21885f464f241c29ff9d7.patch";
      hash = "sha256-cwt4nvtuME//t9KpHgIXHCwLQgpybs2CqV2jO02umfE=";
    })
  ];

  cargoHash = "sha256-OiXpG45jwWydbpRHnbIlECOaa75CzUOmdWxZ3WE5+hY=";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
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
