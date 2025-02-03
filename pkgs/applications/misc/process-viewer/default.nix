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
  version = "0.5.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mEmtLCtHlrCurjKKJ3vEtEkLBik4LwuUED5UeQ1QLws=";
  };

  cargoHash = "sha256-lgVByl+mpCDbhwlC1Eiw9ZkHIDYJsOR06Ds790pXOMc=";

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
    description = "Process viewer GUI in rust";
    homepage = "https://github.com/guillaumegomez/process-viewer";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "process_viewer";
  };
}
