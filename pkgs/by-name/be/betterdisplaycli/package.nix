{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  swift,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "betterdisplaycli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "waydabber";
    repo = "betterdisplaycli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rfJDoPzIsBaKkGhgsGciErAoDycMDojxjYnT+oQZjnA=";
  };

  buildInputs = [ swift ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp betterdisplaycli $out/bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple CLI access for BetterDisplay";
    homepage = "https://github.com/waydabber/betterdisplaycli";
    license = lib.licenses.mit;
    mainProgram = "betterdisplaycli";
    maintainers = [ lib.maintainers.quinneden ];
    platforms = [ "darwin" ];
  };
})
