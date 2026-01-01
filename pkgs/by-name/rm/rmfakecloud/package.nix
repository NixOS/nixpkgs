{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableWebui ? true,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nixosTests,
}:
=======
  nodejs,
  nixosTests,
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmfakecloud";
    rev = "v${version}";
    hash = "sha256-QV8RFg6gATyjIESwO3r5M3Yd9qWFsA6X6bYLmNpLek0=";
  };

  vendorHash = "sha256-ColOCdKa/sKoLnF/3idBIEyFB2JWYM+1y5TdC/LZT4A=";

  # if using webUI build it
  # use env because of https://github.com/NixOS/nixpkgs/issues/358844
  env.pnpmRoot = "ui";
<<<<<<< HEAD
  env.pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    sourceRoot = "${src.name}/ui";
    pnpmLock = "${src}/ui/pnpm-lock.yaml";
    pnpm = pnpm_9;
=======
  env.pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/ui";
    pnpmLock = "${src}/ui/pnpm-lock.yaml";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 1;
    hash = "sha256-uywmHN9HWKi0CaqTg9uEio2XCu6ap9v2xtbodW/6b4Q=";
  };
  preBuild = lib.optionals enableWebui ''
    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r ui/node_modules/sass-embedded ui/node_modules/.pnpm/sass-embedded*

    # avoid re-running pnpm i...
    touch ui/pnpm-lock.yaml

    make ui/dist
  '';
  nativeBuildInputs = lib.optionals enableWebui [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm_9.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  # ... or don't embed it in the server
  postPatch = lib.optionals (!enableWebui) ''
    sed -i '/go:/d' ui/assets.go
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  passthru.tests.rmfakecloud = nixosTests.rmfakecloud;

<<<<<<< HEAD
  meta = {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      euxane
      martinetd
    ];
    mainProgram = "rmfakecloud";
  };
}
