{ lib
, fetchFromGitLab
, rustPlatform
, cargo
, pkg-config
, binutils-unwrapped
, gtk3-x11
, atk
, glib
, librsvg
, gdk-pixbuf
, wrapGAppsHook3
}:

rustPlatform.buildRustPackage rec {
  pname = "pizarra";
  version = "1.7.5";

  src = fetchFromGitLab {
    owner = "categulario";
    repo = "pizarra-gtk";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-vnjhveX3EVIfJLiHWhlvhoPcRx1a8Nnjj7hIaPgU3Zw=";
  };

  cargoHash = "sha256-btvMUKADGHlXLmeKF1K9Js44SljZ0MejGId8aDwPhVU=";

  nativeBuildInputs = [ wrapGAppsHook3 pkg-config gdk-pixbuf ];

  buildInputs = [ gtk3-x11 atk glib librsvg ];

  postInstall = ''
    install -Dm444 res/icons/tk.categulario.pizarra.svg $out/share/icons/hicolor/scalable/apps/pizarra.svg
    install -Dm444 res/pizarra.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/pizarra.desktop \
      --replace "TryExec=/usr/bin/" "TryExec=" \
      --replace "Exec=/usr/bin/" "Exec=" \
      --replace "Icon=/usr/share/icons/hicolor/scalable/apps/pizarra.svg" "Icon=pizarra"
  '';

  meta = with lib; {
    description = "Simple blackboard written in GTK";
    mainProgram = "pizarra";
    longDescription = ''
      A simple endless blackboard.
      Contains various features, such as:
      - Pencil
      - Rectangle
      - Ellipse
      - Line
      - Text
      - Grids
    '';
    homepage = "https://pizarra.categulario.xyz/en/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mglolenstine ];
  };
}
