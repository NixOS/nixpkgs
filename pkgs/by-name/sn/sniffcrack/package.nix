{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  vulkan-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sniffcrack";
  version = "0-unstable-2026-08-19";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "THE-M0P";
    repo = "sniffcrack";
    rev = "44b5b5be5fa04143d45382d4130e9fdbb5213eb6";
    hash = "sha256-9/CbkRk85P/dFNVl8rxEWWSjFwc44vJK1Iv4IXkeVkw=";
  };

  cargoHash = "sha256-hm+p54vCD+rQtuBtp4e2PPGScp+ijGVkZ14tSoeAaWY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
    vulkan-loader
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux Wi-Fi assessment tool for WPA/WPA2 handshake capture and password auditing";
    homepage = "https://github.com/THE-M0P/sniffcrack";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sniffcrack";
    platforms = lib.platforms.linux;
  };
})
