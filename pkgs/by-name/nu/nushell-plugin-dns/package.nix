{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nushell-plugin-dns";
  version = "4.0.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FHGe42cFEadLtZlE8f5dD91aEMDZotYKbS26skmIcQo=";
  };

  cargoHash = "sha256-Yo8wfWuhBfsulLUy+hxiy3hPvKm1o6Z7sVOnwF8Lilw=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # All tests fail with `Error: Io(IoError { kind: DirectoryNotFound, span: Span[60..61], path: Some("."), additional_context: None, location: None })`,
  # probably because of https://github.com/dead10ck/nu_plugin_dns/blob/d4cd3deae47336643dc4f3e7608a8275c6acc984/tests/integration.rs#L173-L179:
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin to query DNS";
    mainProgram = "nu_plugin_dns";
    homepage = "https://github.com/dead10ck/nu_plugin_dns";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ devurandom ];
  };
})
