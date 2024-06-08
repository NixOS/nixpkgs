{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  stdenv,
  darwin,
  wayland,
  gtk-layer-shell,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "anyrun";
  version = "0-unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun";
    rev = "f9d30e34fa4ccb2797c6becec37e8bcff6585d39";
    hash = "sha256-WTO84hUL8IlNuHDK2yOCeJ38EewFzGt5E0kzBjNWxa8=";
  };

  cargoHash = "sha256-RSfAnM3Cq0RUhhzIb9KbebzKAcp/VTORVqctK7PW3XA=";

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      gtk-layer-shell
      pango
    ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ]
    ++ lib.optionals stdenv.isLinux [ wayland ];

  preFixup = ''
    gappsWrapperArgs+=(
     --prefix ANYRUN_PLUGINS : $out/lib
    )
  '';

  postInstall = ''
    install -Dm444 anyrun/res/style.css examples/config.ron -t $out/share/doc/${pname}/examples/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A wayland-native, highly customizable runner";
    homepage = "https://github.com/anyrun-org/anyrun";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      eclairevoyant
      NotAShelf
    ];
    mainProgram = "anyrun";
  };
}
