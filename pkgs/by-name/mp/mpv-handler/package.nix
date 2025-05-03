{
  lib,
  rustPlatform,
  fetchFromGitHub,

  mpv,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpv-handler";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-NSDcGzeO8+oPKs0xTE6qcZsT/huhcQLBFuAqLg3tyMs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MkJafUgkb929NPCifp7cpHNkViixiQ+FSHKzBWSrOC0=";

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
