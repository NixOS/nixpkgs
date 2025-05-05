{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_units";
  version = "0.1.5";

  src = fetchFromGitHub {
    repo = "nu_plugin_units";
    owner = "JosephTLyons";
    rev = "v${version}";
    hash = "sha256-Uw8OcfSETRceaoEnJP1B++v0SqGjzaYz1wCMVMe774s=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-3v9jP8nL0JqtC76igsCytkQAVTgWqzHH0KQX3o6bi0c=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoBuildFlags = [ "--package nu_plugin_units" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin for easily converting between common units.";
    mainProgram = "nu_plugin_units";
    homepage = "https://github.com/JosephTLyons/nu_plugin_units";
    license = licenses.mit;
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; all;
  };
}
