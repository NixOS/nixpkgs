{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,

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
  version = "1.11.1";
  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "fedistar";
    tag = "v${version}";
    hash = "sha256-uAZUfYHFAfCToljXDq+yZhZp1P7vzmVUJ6rezbO1ykQ=";
  };
  fedistar-frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "fedistar-frontend";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      hash = "sha256-URMji1WTXVvX3gEYEG47IJGGTeh0wTJShy/eTZI5Xsw=";
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
  inherit
    pname
    version
    src
    fedistar-frontend
    ;
  sourceRoot = "${src.name}/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-Njan03/3D5KdN8IcGsfHBevXqy3b44SgfYj2exhAaVM=";

  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"frontendDist": "../out",' '"frontendDist": "${fedistar-frontend}",' \
      --replace-fail '"beforeBuildCommand": "pnpm build",' '"beforeBuildCommand": "",'
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

  # A fix for a problem with Tauri (tauri-apps/tauri#9304)
  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "fedistar-frontend"
    ];
  };

  meta = {
    description = "Multi-column Fediverse client application for desktop";
    homepage = "https://fedistar.net/";
    mainProgram = "fedistar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ noodlez1232 ];
    changelog = "https://github.com/h3poteto/fedistar/releases/tag/v${version}";
  };
}
