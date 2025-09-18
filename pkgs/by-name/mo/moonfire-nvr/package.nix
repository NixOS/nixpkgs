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
  pnpm_9,
}:

let
  pname = "moonfire-nvr";
  version = "0.7.20";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    tag = "v${version}";
    hash = "sha256-0EaGqZUmYGxLHcJAhlbG2wZMDiVv8U1bcTQqMx0aTo0=";
  };
  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "${src.name}/ui";
    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];
    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 1;
      hash = "sha256-7fMhUFlV5lz+A9VG8IdWoc49C2CTdLYQlEgBSBqJvtw=";
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

  cargoHash = "sha256-+L4XofUFvhJDPGv4fAGYXFNpuNd01k/P63LH2tXXHE0=";

  env.VERSION = "v${version}";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/lib/ui
    ln -s ${ui} $out/lib/ui
  '';

  doCheck = false;

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      inherit version;
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
    };
  };

  meta = {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "moonfire-nvr";
  };
}
