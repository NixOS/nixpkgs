{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableWebui ? true,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nixosTests,
}:
buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmfakecloud";
    rev = "v${version}";
    hash = "sha256-N6hAv8dVCM3VWuKpHlK82mjQh6RB7W+n9KBNNQXDrC8=";
  };

  vendorHash = "sha256-XksCJ9b5NDIutwqnWP63R2udp/Y5qkkgo2a4TPUi0Z4=";

  # if using webUI build it
  # use env because of https://github.com/NixOS/nixpkgs/issues/358844
  env.pnpmRoot = "ui";
  env.pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    sourceRoot = "${src.name}/ui";
    pnpmLock = "${src}/ui/pnpm-lock.yaml";
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-5dsrf6Iff8z4ujzUccuNFwChChbWzXeXDilh8uZyl+U=";
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
    pnpmConfigHook
    pnpm_9
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

  meta = {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      euxane
      martinetd
    ];
    mainProgram = "rmfakecloud";
  };
}
