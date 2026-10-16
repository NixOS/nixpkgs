{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_units";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "JosephTLyons";
    repo = "nu_plugin_units";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VJh1+naxVbf3Lqw73xvvzM2o4YuZxsQ68j4QhZHsaBQ=";
  };

  cargoHash = "sha256-fqyh8FzDDL37Nud3XbVp+Tew4LT10j++WY69HTVTnx8=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for easily converting between common units";
    mainProgram = "nu_plugin_units";
    homepage = "https://github.com/JosephTLyons/nu_plugin_units";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mgttlinger ];
    # "Plugin `units` is compiled for nushell version 0.106.1, which is not
    # compatible with version 0.115.1"
    broken = true;
  };
})
