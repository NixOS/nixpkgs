{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  pango,
  polkit,
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "soteria";
  inherit version;

  src = fetchFromGitHub {
    owner = "imvaskel";
    repo = "soteria";
    tag = "v${version}";
    hash = "sha256-CinJEzH4GsCAzU8FiInulPHLm73KI4nLlAcskkjgeJM=";
  };

  cargoHash = "sha256-vv7gK0ZfwO2AHXXQcXfkne9wZl+8JH9h8vELdRjg8WM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    pango
  ];

  # From upstream packaging:
  #  Takes advantage of nixpkgs manually editing PACKAGE_PREFIX by grabbing it from
  #  the binary itself.
  #  https://github.com/NixOS/nixpkgs/blob/9b5328b7f761a7bbdc0e332ac4cf076a3eedb89b/pkgs/development/libraries/polkit/default.nix#L142
  #  https://github.com/polkit-org/polkit/blob/d89c3604e2a86f4904566896c89e1e6b037a6f50/src/polkitagent/polkitagentsession.c#L599
  preBuild = ''
    export POLKIT_AGENT_HELPER_PATH="$(strings ${polkit.out}/lib/libpolkit-agent-1.so | grep "polkit-agent-helper-1")"
  '';

  meta = {
    description = "Polkit authentication agent written in GTK designed to be used with any desktop environment";
    homepage = "https://github.com/ImVaskel/soteria";
    license = lib.licenses.asl20;
    mainProgram = "soteria";
    maintainers = with lib.maintainers; [
      NotAShelf
    ];
    inherit (polkit.meta) platforms;
  };
}
