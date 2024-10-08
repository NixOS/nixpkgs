{ lib
, stdenv
, testers
, fetchFromGitHub
, rustPlatform
, darwin
, numbat
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-MYoNziQiyppftLPNM8cqEuNwUA4KCmtotQqDhgyef1E=";
  };

  cargoHash = "sha256-t6vxJ0UIQJILCGv4PO5V4/QF5de/wtMQDkb8gPtE70E=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env.NUMBAT_SYSTEM_MODULE_PATH = "${placeholder "out"}/share/numbat/modules";

  postInstall = ''
    mkdir -p $out/share/numbat
    cp -r $src/numbat/modules $out/share/numbat/
  '';

  passthru.tests.version = testers.testVersion {
    package = numbat;
  };

  meta = with lib; {
    description = "High precision scientific calculator with full support for physical units";
    longDescription = ''
      A statically typed programming language for scientific computations
      with first class support for physical dimensions and units
    '';
    homepage = "https://numbat.dev";
    changelog = "https://github.com/sharkdp/numbat/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    mainProgram = "numbat";
    maintainers = with maintainers; [ giomf atemu ];
  };
}
