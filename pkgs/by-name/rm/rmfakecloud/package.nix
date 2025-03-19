{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableWebui ? true,
  pnpm_9,
  nodejs,
  nixosTests,
}:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmfakecloud";
    rev = "v${version}";
    hash = "sha256-XlKqh6GKGreWLPjS8XfEUJCMMxiOw8pP2qX8otD+RCo=";
  };

  vendorHash = "sha256-9tfxE03brUvCYusmewiqNpCkKyIS9qePqylrzDWrJLY=";

  # if using webUI build it
  # use env because of https://github.com/NixOS/nixpkgs/issues/358844
  env.pnpmRoot = "ui";
  env.pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/ui";
    pnpmLock = "${src}/ui/pnpm-lock.yaml";
    hash = "sha256-VNmCT4um2W2ii8jAm+KjQSjixYEKoZkw7CeRwErff/o=";
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
    pnpm_9.configHook
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

  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      euxane
      martinetd
    ];
    mainProgram = "rmfakecloud";
  };
}
