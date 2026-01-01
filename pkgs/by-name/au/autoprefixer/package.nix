{
  lib,
  stdenv,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  callPackage,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "autoprefixer";
<<<<<<< HEAD
  version = "10.4.23";
=======
  version = "10.4.22";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "autoprefixer";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-sz4tE0WqSHJ4ExJ0yL24mTux5/eGuhIyKyrZqs4hSxQ=";
=======
    hash = "sha256-cIUotZ+RFmwD6mf31k69VwZtX7bSIUVvwoUutkyt3qU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-xPG67b54h+KmDrCgMmTVVVnBah9L6rgjh+EWnEzzI0w=";
=======
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-gqxspt7fX8+Ss/uUBq834fTfV5tVKZREC4e1WtE+7WM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
