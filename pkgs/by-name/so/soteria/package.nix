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
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  pname = "soteria";
  inherit version;

  src = fetchFromGitHub {
    owner = "imvaskel";
    repo = "soteria";
    tag = "v${version}";
    hash = "sha256-bZhxz6aycx7J3itInSsl2glbIs6OpIEkfSp3nYfPojk=";
  };

  cargoHash = "sha256-rxZRDx+5srBbMTVLMNH8liOqjyg90FvTaTT7g+3fq7E=";

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
