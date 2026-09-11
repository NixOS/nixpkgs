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
  version = "10.5.5";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "autoprefixer";
    tag = finalAttrs.version;
    hash = "sha256-LESTo+iuCle/lQiaZ3djlV9cAbdvbNTW3QG96bS7cUU=";
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
    hash = "sha256-y+BCaXaLeHDXwMmSnZlP9RjEwaCCVF5ZHP0XhvHm1Tk=";
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
