{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  alsa-lib,
  alsa-plugins,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lowfi";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = finalAttrs.version;
    hash = "sha256-/GU1e01AjeS4AVBvQUi/GZKeQ0X+hnmt+kyW3gp0jgg=";
  };

  cargoHash = "sha256-iuC0YBhzK8mATJekTgBDMiXATRdThem35p5AyDXQNGo=";

  buildFeatures = [ "scrape" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "mpris" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    alsa-plugins
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/lowfi \
      --set ALSA_PLUGIN_DIR "${alsa-plugins}/lib/alsa-lib"
  '';

  checkFlags = [
    # Skip this test as it doesn't work in the nix sandbox
    "--skip=tests::tracks::list::download"
  ];

  meta = {
    description = "Extremely simple lofi player";
    homepage = "https://github.com/talwat/lowfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zsenai ];
    mainProgram = "lowfi";
  };
})
