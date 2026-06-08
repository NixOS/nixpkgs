{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  sqlite,
  testers,
  moonfire-nvr,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

let
  pname = "moonfire-nvr";
  version = "0.7.31";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    tag = "v${version}";
    hash = "sha256-QgsaiWcXeU4y7z9mcqUAl4mQ/M4p38yRjOB/4MKlpVA=";
  };
  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "${src.name}/ui";
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 4;
      hash = "sha256-U/SHOVlx0kj1hfl09KcPg3CQZX9HZE5SghVEThWL1RA=";
    };
    installPhase = ''
      runHook preInstall

      cp -r public $out

      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/server";

  cargoHash = "sha256-TDFe5pD+8eSwvw0h9GLM+JfODlSBU1CO8fw4FVjy8xk=";

  env.VERSION = "v${version}";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/lib
    ln -s ${ui} $out/lib/ui
  '';

  doCheck = false;

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
      version = "Version: v${version}";
    };
  };

  meta = {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "moonfire-nvr";
  };
}
