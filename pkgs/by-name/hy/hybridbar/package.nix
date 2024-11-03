{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  cairo,
  gtk3,
  gtk-layer-shell,
}:

rustPlatform.buildRustPackage rec {
  pname = "HybridBar";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "vars1ty";
    repo = "HybridBar";
    rev = "v${version}";
    hash = "sha256-e9QVDDN8AtCZYuYqef1rzLJ0mklaKXzxgj+ZqGrSYEY=";
  };

  cargoHash = "sha256-50Go2AJQqgG2chc70KqKJexffD1rpObXr85ZPAIqc/U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    glib
    pango
    cairo
  ];

  meta = {
    description = "Status bar focused on wlroots Wayland compositors";
    homepage = "https://github.com/vars1ty/HybridBar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ixi2101 ];
    mainProgram = "hybrid-bar";
  };
}
