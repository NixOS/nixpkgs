{
  lib,
  cmake,
  dbus,
  fetchFromGitHub,
  fetchPnpmDeps,
  freetype,
  gtk3,
  libayatana-appindicator,
  libsoup_3,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

let

  pname = "cc-switch";
  version = "3.12.3";

  src = fetchFromGitHub {
    owner = "farion1231";
    repo = "cc-switch";
    rev = "v${version}";
    hash = "sha256-+gHxOAumI/ZUukFNc9ks22bkqbOky6F7MYZzGwrXRRc=";
  };

  frontend-build = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "cc-switch";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-bLL8ZcZlUWERcOikFCfN5MPqH/VocCfvDJqrkAPbtPA=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    buildPhase = ''
      runHook preBuild

      pnpm run build:renderer

      runHook postBuild
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });
in

rustPlatform.buildRustPackage {
  inherit version src pname;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-S6fdv71Haonmmair2/mplcKLBwkUNKTOpPI4dRgi8/s=";

  # copy the frontend static resources to final build directory
  postPatch = ''
    cp -r ${frontend-build} dist
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    dbus
    openssl
    freetype
    libayatana-appindicator
    libsoup_3
    gtk3
    webkitgtk_4_1
  ];

  checkFlags = [
    # tries to mutate the parent directory
    "--skip=test_file_operation"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
    )
  '';

  meta = {
    description = "All-in-One Assistant for Claude Code, Codex & Gemini CLI";
    homepage = "https://github.com/farion1231/cc-switch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chansuke ];
    mainProgram = "cc-switch";
  };
}
