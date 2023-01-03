{ lib
, rustPlatform
, fetchCrate
, pkg-config
, gtk4
, stdenv
, DiskArbitration
, Foundation
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "process-viewer";
  version = "0.5.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-MHVKjbD1/h7G94x6dpyRT/BPWQVUFurW7EvAUJ2xZeU=";
  };

  cargoSha256 = "sha256-NkJjwB4rBV4hFRwYHILMET8o4x1+95sVsFqNaVN8tMg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ] ++ lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    IOKit
  ];

  postInstall = ''
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.desktop -t $out/share/applications
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 assets/fr.guillaume_gomez.ProcessViewer.metainfo.xml -t $out/share/metainfo
  '';

  meta = with lib; {
    description = "A process viewer GUI in rust";
    homepage = "https://github.com/guillaumegomez/process-viewer";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "process_viewer";
  };
}
