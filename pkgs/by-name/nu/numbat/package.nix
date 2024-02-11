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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-zMgZ/QmpZaB+4xdxVBE3C8CWS/aNCDuowDWOg65PhTo=";
  };

  cargoHash = "sha256-x6SMQoiDf0GoyOJGP8S69wJnY/nCvo6Bq5KQyrgY+Gs=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env.NUMBAT_SYSTEM_MODULE_PATH = "${placeholder "out"}/share/${pname}/modules";

  postInstall = ''
    mkdir -p $out/share/${pname}
    cp -r $src/${pname}/modules $out/share/${pname}/
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
