{
  lib,
  stdenvNoCC,
  fetchFromGitHub,

  pnpm_10,
  nodejs,

  rustPlatform,
  cargo-tauri,
  wrapGAppsHook4,
  pkg-config,
  glib-networking,
  webkitgtk_4_1,
  openssl,
}:
let
  pnpm = pnpm_10;
  pname = "fedistar";
  version = "1.11.0";
  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "fedistar";
    tag = "v${version}";
    hash = "sha256-x7PljFqxC3Zht3ZEAZTA6/BClZ0g7VH2HpQLGKqQ8qo=";
  };
  frontend-build = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "fedistar-frontend";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      hash = "sha256-RqTAb01W8/qcQonh44bT7zeeJEuLekfZW66mfT2vYYw=";
    };
    nativeBuildInputs = [
      pnpm.configHook
      pnpm
      nodejs
    ];

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r out/* $out/
      runHook postInstall
    '';
  });

in
rustPlatform.buildRustPackage {
  inherit version pname src;
  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-Nsb0UTYSGbMbgtOzo7I3X16Qv61ZeohksrwbB0Xr1Xw=";
  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace '"frontendDist": "../out",' '"frontendDist": "${frontend-build}",' \
      --replace '"beforeBuildCommand": "pnpm build",' '"beforeBuildCommand": "",'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook

    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_1
    ];

  doCheck = false; # This version's tests do not pass

  meta = {
    description = "Multi-column Fediverse client application for desktop";
    homepage = "https://fedistar.net/";
    mainProgram = "fedistar";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.noodlez1232 ];
    changelog = "https://github.com/h3poteto/fedistar/releases/tag/v${version}";
  };
}
