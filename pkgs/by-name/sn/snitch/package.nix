{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  apple-sdk_15,
}:

buildGoModule (finalAttrs: {
  pname = "snitch";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "karol-broda";
    repo = "snitch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/0MYXKBat+OumuXnS8XSiMslNHUopVDFO4RdYGECfI8=";
  };

  vendorHash = "sha256-fX3wOqeOgjH7AuWGxPQxJ+wbhp240CW8tiF4rVUUDzk=";

  # these below settings (env, buildInputs, ldflags) copied from
  # https://github.com/karol-broda/snitch/blob/master/flake.nix

  env = {
    # darwin requires cgo for libproc, linux uses pure go with /proc
    CGO_ENABLED = if stdenv.hostPlatform.isDarwin then 1 else 0;
  };

  # darwin: use macOS 15 SDK for SecTrustCopyCertificateChain (Go 1.25 crypto/x509)
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  ldflags = [
    "-s"
    "-w"
    "-X snitch/cmd.Version=${finalAttrs.version}"
    "-X snitch/cmd.Commit=v${finalAttrs.version}"
    "-X snitch/cmd.Date=1970-01-01"
  ];

  meta = {
    description = "friendlier ss / netstat for humans";
    homepage = "https://github.com/karol-broda/snitch";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.DieracDelta ];
    platforms = lib.platforms.unix;
    mainProgram = "snitch";
  };
})
