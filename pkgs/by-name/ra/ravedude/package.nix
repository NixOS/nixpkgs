{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  udev,
  avrdude,
  makeBinaryWrapper,
  nix-update-script,
  testers,
  ravedude,
}:

rustPlatform.buildRustPackage rec {
  pname = "ravedude";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LYHWUVREnGNR/vqtj+VklV3o74KUJu+Yi8ftulCJt9s=";
  };

  cargoHash = "sha256-rD8rFs3zfWjQXm3mLvY2tpVS6X8wHJka2qs4D3/pa4E=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [ udev ];

  postInstall = ''
    wrapProgram $out/bin/ravedude --suffix PATH : ${lib.makeBinPath [ avrdude ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = ravedude;
      version = "v${version}";
    };
  };

  meta = {
    description = "Tool to easily flash code onto an AVR microcontroller with avrdude";
    homepage = "https://crates.io/crates/ravedude";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rvarago
      liff
    ];
    mainProgram = "ravedude";
  };
}
