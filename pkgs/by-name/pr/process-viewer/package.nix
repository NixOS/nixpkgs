{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  gtk4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "process-viewer";
  version = "0.5.11";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "process_viewer";
    hash = "sha256-d2qEcb9iPnhNnRFbzbktk36hyL16opcDgE9xOnmlJGg=";
  };

  cargoHash = "sha256-UD0eTRfHimp6ZGStvrP1upUe3yO3Mw96Sq3OG4Y7zn0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ];

  postInstall = ''
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.desktop -t $out/share/applications
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.metainfo.xml -t $out/share/metainfo
  '';

  meta = {
    description = "Process viewer GUI in rust";
    homepage = "https://github.com/guillaumegomez/process-viewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      kybe236
    ];
    mainProgram = "process_viewer";
  };
})
