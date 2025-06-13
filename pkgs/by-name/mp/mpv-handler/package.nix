{
  lib,
  rustPlatform,
  fetchFromGitHub,

  mpv,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpv-handler";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-QqglGTXUBdClphZYBmxjbw5qJXDPQasR99H3n+5BIRw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GiGQkEMPzoepjBbGXo2aFjV/pyn+BvToLDNSlASNcnM=";

  buildInputs = [ mpv ];

  postInstall = ''
    mkdir -p $out/share/applications
    install -Dm644 share/linux/mpv-handler.desktop $out/share/applications/
    install -Dm644 share/linux/mpv-handler-debug.desktop $out/share/applications/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protocol handler for mpv";
    homepage = "https://github.com/akiirui/mpv-handler";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ d-brasher ];
    mainProgram = "mpv-handler";
  };
})
