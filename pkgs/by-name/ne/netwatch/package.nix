{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libpcap,
}:

rustPlatform.buildRustPackage rec {
  pname = "netwatch";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${version}";
    hash = "sha256-Isv5xtR8NDB6zU45Kfu0JAbe0MHyUYYJStZh0ble0fY=";
  };

  cargoHash = "sha256-+/GK9now28Ujidp888EQDlturehDv3v2woO9xq5p/3U=";

  buildInputs = [
    libpcap
  ];

  __structuredAttrs = true;

  meta = {
    description = "Real-time network diagnostics in your terminal";
    longDescription = ''
      Real-time network diagnostics in your terminal.
      One command, zero config, instant visibility.
    '';
    homepage = "https://github.com/matthart1983/netwatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blemouzy ];
    mainProgram = "netwatch";
  };
}
