{ lib
, rustPlatform
, fetchCrate
, pkg-config
, gtk4
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "process-viewer";
  version = "0.5.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ELASfcXNhUCE/mhPKBHA78liFMbcT9RB/aoLt4ZRPa0=";
  };

  cargoSha256 = "sha256-K2kyZwKRALh9ImPngijgpoHyLS+c5sDYviN74JxhJLM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
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
