{
  lib,
  stdenv,
  nodejs,
  pnpm_9,
  fetchFromGitHub,
  callPackage,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "autoprefixer";
  version = "10.4.21";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "autoprefixer";
    rev = finalAttrs.version;
    hash = "sha256-25FVNUXMEuzPJtpld/GHEppspa2ns7fAuniBCltSync=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-zb/BwL//i0oly5HEXN20E3RzZXdaOn+G2yIWRas3PB4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv bin/ $out
    mv lib/ $out
    mv node_modules/ $out
    mv data/ $out
    mv package.json $out

    runHook postInstall
  '';

  postFixup = ''
    patchShebangs $out/bin/autoprefixer
  '';

  passthru = {
    tests = {
      simple-execution = callPackage ./tests/simple-execution.nix { };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Parse CSS and add vendor prefixes to CSS rules using values from the Can I Use website";
    homepage = "https://github.com/postcss/autoprefixer";
    changelog = "https://github.com/postcss/autoprefixer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "autoprefixer";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
