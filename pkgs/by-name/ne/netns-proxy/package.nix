{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netns-proxy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fooker";
    repo = "netns-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sTOhoiBCKognc5SIj9SVfhyjnuatHbIRNtQ73SxWX+Q=";
  };

  cargoHash = "sha256-rf4cazRrHxHdT4U58sJtAHU2pfZ5+oAerSVdEt9/bGA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and slim proxy to forward ports from and into linux network namespaces";
    homepage = "https://github.com/fooker/netns-proxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "netns-proxy";
    maintainers = with lib.maintainers; [ fooker ];
  };
})
