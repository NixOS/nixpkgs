{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfdyndns";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "nrdxp";
    repo = "cfdyndns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OV1YRcZDzYy1FP1Bqp9m+Jxgu6Vc0aWpbAffNcdIW/4=";
  };

  cargoHash = "sha256-VA4oT8WeXdxjr/tKbrRuZPLpXmmXbeKC5d6laRHr+uo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "CloudFlare Dynamic DNS Client";
    mainProgram = "cfdyndns";
    homepage = "https://github.com/nrdxp/cfdyndns";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      colemickens
    ];
    platforms = with lib.platforms; linux;
  };
})
