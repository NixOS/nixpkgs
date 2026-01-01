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
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];
=======
  buildInputs = [ udev ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Tool to easily flash code onto an AVR microcontroller with avrdude";
    homepage = "https://crates.io/crates/ravedude";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool to easily flash code onto an AVR microcontroller with avrdude";
    homepage = "https://crates.io/crates/ravedude";
    license = with licenses; [
      mit # or
      asl20
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      rvarago
      liff
    ];
    mainProgram = "ravedude";
  };
}
