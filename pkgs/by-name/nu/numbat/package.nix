{
  lib,
  stdenv,
  testers,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  darwin,
  numbat,
  tzdata,
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-o3EYhMFBgs/Ni+YCM3+RdUYlwRt+nMaEP/cAkDXMVHc=";
  };

  cargoHash = "sha256-rK9RPd/hww2F87l/dd14pB4izE58NuqaewYaqMimV1M=";

  patches = [
    # https://github.com/sharkdp/numbat/pull/562
    (fetchpatch {
      url = "https://github.com/sharkdp/numbat/commit/4756a1989ecdab35fd05ca18c721ed15d8cde2b1.patch";
      hash = "sha256-22+yePjy+MxJQ60EdvgaTw/IVV0d/wS2Iqza1p1xmfk=";
    })
  ];

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
    broken = stdenv.isDarwin;
  };
}
