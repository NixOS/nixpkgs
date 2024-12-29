{
  rustPlatform,
  fetchFromGitHub,
  libxcb,
  python3,
  makeWrapper,
  steam-run,
  lib
}:

rustPlatform.buildRustPackage rec {
  pname = "noita_entangled_worlds";
  version = "0.32.8";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = pname;
    rev = version;
    hash = "sha256-mB5pV2ilIIbgR9kskLigHY5cUVbIK9/7PllbeYv9gEU=";
  };

  sourceRoot = "${src.name}/noita-proxy";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  patches = [ ./00-save-location.patch ];

  buildInputs = [
    libxcb
    steam-run
  ];

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  doCheck = false;

  postInstall = ''
    cp ${src}/redist/libsteam_api.so $out/bin/
    mv $out/bin/noita-proxy $out/bin/.noita-proxy-unwrapped

    # Wrap with steam-run so Noita will launch
    makeWrapper ${steam-run}/bin/steam-run $out/bin/noita-proxy \
      --add-flags "$out/bin/.noita-proxy-unwrapped"
  '';

    meta = {
    changelog = "https://github.com/IntQuant/noita_entangled_worlds/releases/tag/v${version}";
    description = "True coop multiplayer mod for Noita";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ totaltax ];
    platforms = lib.platforms.linux;
    mainProgram = "noita-proxy";
  };
}
