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
  pname = "jellyhaj";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "owo-uwu-nyaa";
    repo = "jellyhaj";
    tag = "v0.2.0";
    hash = "sha256-eZrCw0237tnYu9s/5s0QyX2CaIqW6rnMeYrLH2Wch9w=";
  };
  cargoHash = "sha256-ehzgNaDg3dNZzb5Qe8vk/ZDVglynm+wjVpafFS53iGk=";
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
  __structuredAttrs = true;

  meta = {
    description = "Terminal client for Jellyfin trying to reimplement parts of the web ui";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "jellyhaj";
    homepage = "https://github.com/owo-uwu-nyaa/jellyhaj";
    maintainers = with lib.maintainers; [ RobinMarchart ];
  };
}
