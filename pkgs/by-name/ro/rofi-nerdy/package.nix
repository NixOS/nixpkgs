{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  cairo,
  pango,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rofi-nerdy";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "rofi-nerdy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RiQ8bP7Q1ItZfCO94R95aTenqVOD45ohfUdmtDn0r9k=";
  };

  cargoHash = "sha256-NvS38uTqlBTUmRg2z0Faa5bTlRC/DTXQU3MCcSmPerA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    cairo
    pango
  ];

  postInstall = ''
    mkdir -p $out/lib/rofi
    mv $out/lib/librofi_nerdy.so $out/lib/rofi/nerdy.so
  '';

  meta = {
    description = "Nerd font icon selector plugin for rofi";
    homepage = "https://github.com/Rolv-Apneseth/rofi-nerdy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xavwe ];
    platforms = lib.platforms.linux;
  };
})
