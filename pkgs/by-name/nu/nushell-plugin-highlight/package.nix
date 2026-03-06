{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_highlight";
  version = "1.4.13+0.111.0";

  src = fetchFromGitHub {
    owner = "cptpiepmatz";
    repo = "nu-plugin-highlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vPQgg5A7e+S9SzgscicmcwLhvusWT9+5GoTImiW0pQ4=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-56u6Yaz5YZNJTXYlb3xZiaGYB5Lte2pPIHX7TmhXPrU=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`nushell` plugin for syntax highlighting";
    mainProgram = "nu_plugin_highlight";
    homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
