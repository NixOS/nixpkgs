{
  lib,
  stdenv,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  callPackage,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "autoprefixer";
  version = "10.6.1";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "autoprefixer";
    tag = finalAttrs.version;
    hash = "sha256-RQmZrZDIeBej+yt4xN77opzxj5y0gI0wijdnLt/NeU0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-wFy3YsQk1JAlXW53J1rseQ7UpxyoKStANbb+Eqioo/0=";
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
    changelog = "https://github.com/postcss/autoprefixer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "autoprefixer";
    maintainers = [ lib.maintainers.skohtv ];
  };
})
