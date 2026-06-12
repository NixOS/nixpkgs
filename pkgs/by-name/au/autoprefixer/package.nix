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
  version = "10.4.24";

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "autoprefixer";
    rev = finalAttrs.version;
    hash = "sha256-9XZWkBDqkaBbIHq3wIbo4neToPM+NCxi9c1AyVqmnvc=";
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
    hash = "sha256-Sxt4vtdlMdXxXqt22hfZJskj8mkB5t85IZ5BsbCoDF4=";
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
    maintainers = [ ];
  };
})
