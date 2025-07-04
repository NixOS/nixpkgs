{
  fetchFromGitHub,
  lib,
  moonfire-nvr,
  ncurses,
  nodejs,
  pkg-config,
  pnpm,
  rustPlatform,
  sqlite,
  stdenv,
  testers,
  tzdata,
  ...
}:

let
  pname = "moonfire-nvr";
  version = "0.7.21";

  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    tag = "v${version}";
    hash = "sha256-fkWdMFQw414en3dLzq+JulebC5GSuKIUnYIw7a92/uI=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-ui";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/ui";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;

      fetcherVersion = 1;
      hash = "sha256-vUrVRFa+24nsxOu6h87fgyUSe8ZX2gnvLakpndm4OnQ=";

    };

    installPhase = ''
      runHook preInstall

      pnpm install
      pnpm run build

      mkdir $out
      mv dist/* $out

      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;

  sourceRoot = "${finalAttrs.src.name}/server";
  cargoHash = "sha256-87iaOOMFpvWBP3Khjrey3pDBGnA7gY01et5xWGWoIlY=";

  buildFeatures = [ "bundled-ui" ];

  nativeBuildsInputs = [ pkg-config ];
  buildInputs = [
    ncurses
    sqlite
    tzdata
  ];

  doCheck = false;

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      inherit version;
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
    };
  };

  env = {
    UI_DIST_DIR = ui;
    VERSION = version;
  };

  meta = {
    description = "Security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      gaelreyrol
      PopeRigby
    ];
    mainProgram = "moonfire-nvr";
  };
})
