{
  lib,
  stdenv,
  testers,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  numbat,
  tzdata,
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-TmzM541S2W5Cy8zHEWKRE2Zj2bSgrM4vbsWw3zbi3LQ=";
  };

  cargoHash = "sha256-exvJJsGIj6KhmMcwhPjXMELvisuUtl17BAO6XEJSJmI=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env.NUMBAT_SYSTEM_MODULE_PATH = "${placeholder "out"}/share/numbat/modules";

  postInstall = ''
    mkdir -p $out/share/numbat
    cp -r $src/numbat/modules $out/share/numbat/
  '';

  preCheck = ''
    # The datetime library used by Numbat, "jiff", always attempts to use the
    # system TZDIR on Unix and doesn't fall back to the embedded tzdb when not
    # present.
    export TZDIR=${tzdata}/share/zoneinfo
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
    license = with licenses; [
      asl20
      mit
    ];
    mainProgram = "numbat";
    maintainers = with maintainers; [
      giomf
      atemu
    ];
    # Failing tests on Darwin.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
