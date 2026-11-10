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
  version = "1.4.17+0.115.1";

  src = fetchFromGitHub {
    owner = "cptpiepmatz";
    repo = "nu-plugin-highlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8yXDP3VKIGjqKPKhQJvDlYBLyl4pplqXqFgL58q4oJg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-56PVP1pw6cJVmfd3O3so6YmFro1jvN1R++nnanItBUQ=";

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
    # "Plugin `highlight` is compiled for nushell version 0.114.1, which is
    # not compatible with version 0.115.1"
    broken = true;
  };
})
