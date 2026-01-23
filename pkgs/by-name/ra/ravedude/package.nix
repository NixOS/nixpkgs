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
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "ravedude";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ar2oQx7dKKfzkM3FMcJXiPHxNa0KcMRht38q+NgowfU=";
  };

  cargoHash = "sha256-ME9egPOMTv/nEsmuxI+gJ6Tqa1Vqc/enlPttHXfTdBg=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      rvarago
      liff
    ];
    mainProgram = "ravedude";
  };
}
