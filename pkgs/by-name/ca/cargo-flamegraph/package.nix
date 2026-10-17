{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  perf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-flamegraph";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tjphY9qZaKkqrbwm8lszyyIBpaKZx644LudBq81qngU=";
  };

  cargoHash = "sha256-mSItpfrGRFL9L3Rlqsvx+FdYyJL8rcWWS8Abyixto7c=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/cargo-flamegraph \
      --set-default PERF ${perf}/bin/perf
    wrapProgram $out/bin/flamegraph \
      --set-default PERF ${perf}/bin/perf
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/flamegraph-rs/flamegraph";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      killercup
      matthiasbeyer
    ];
  };
})
