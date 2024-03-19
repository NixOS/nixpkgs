{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cryptsetup,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "sha256-bXwaFiRHURvS5KtTqIj+3GlGNbEulDgMDP51ZiO1w9o=";
  };

  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -s ${./Cargo.toml} Cargo.toml
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ cryptsetup ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ctap_hmac-0.4.5" = "sha256-3IL8bHxJEblPkHptjifltcmMNOBn5ZJl5emImJr1O5o=";
    };
  };

  meta = {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      prusnak
      mmahut
      quantenzitrone
    ];
    platforms = lib.platforms.linux;
  };
}
