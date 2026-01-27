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
  version = "v3.8.3";

  src = fetchFromGitHub {
    owner = "farion1231";
    repo = "cc-switch";
    rev = "91deaf094e1593d16961968fcbfdac22c1205449";
    sha256 = "09m1s2a1f4qvnvpf8a0afi98mzbxw8jiz2l4hmkawzcppnb7vgif";
  };

  frontend-build = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "cc-switch";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 1;
      hash = "sha256-haIttZ+8zEHJMMR7xrn4DMYPmEfDcE01NWG9vg7iJFg=";
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

  cargoHash = "sha256-La3iv9ebQrqOI7nLLdGsLzQrhdPsaDvlJiKD9/pseZ0=";

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
