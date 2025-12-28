{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  mpv-unwrapped,
  sqlite,
  versionCheckHook,
  mpris ? stdenv.isLinux,
}:

rustPlatform.buildRustPackage {
  pname = "jellyfin-tui-rs";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "owo-uwu-nyaa";
    repo = "jellyfin-tui-rs";
    rev = "594fb385bbf2e245ce8f3650713219fa43772be2";
    hash = "sha256-eDQUwIPdBPCKTnPx1KuPTCnmomnJlVEhKc7MsKwAp8g=";
  };
  cargoHash = "sha256-/LCuE2XtO0whVbDBGMC43M2OdZWA/PDw9Oea6LYutm0=";
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    sqlite
    mpv-unwrapped
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  checkFlags = [
    #some tests need internet access
    "--skip=tests::properties"
    "--skip=tests::node_map"
    "--skip=tests::events"
  ];
  cargoTestFlags = [ "--workspace" ];
  buildFeatures = lib.optional mpris "mpris";

  meta = {
    description = "Terminal client for Jellyfin trying to reimplement parts of the web ui";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "jellyfin-tui-rs";
    homepage = "https://github.com/owo-uwu-nyaa/jellyfin-tui-rs";
    maintainers = with lib.maintainers; [ RobinMarchart ];
  };
}
