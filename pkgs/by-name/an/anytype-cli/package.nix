{
  lib,
  buildGoModule,
  fetchFromGitHub,
  tantivy-go,
  zstd,
  versionCheckHook,
  nix-update-script,
  stdenv,
  darwin,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "anytype-cli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qob8abtP9TSbRSi1WZtKx8uLJCyo+PmQXdjvI6FzOo8=";
  };

  vendorHash = "sha256-4MkXsSCa4c6aXLJ/tZ5w0tE3BnGkTak4lprrozs61oI=";
  proxyVendor = true;

  env.CGO_ENABLED = 1;
  env.CGO_LDFLAGS = "-L${tantivy-go}/lib";

  buildInputs = [ zstd ];
  env.NIX_LDFLAGS = "-lzstd";

  preCheck = "export ${
    if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
  }=${lib.makeLibraryPath [ zstd ]}";

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.file_cmds ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmd/machine/machine_darwin_test.go core/localstate/acl_darwin_test.go \
      --replace-fail '"/bin/chmod"' '"${lib.getExe' darwin.file_cmds "chmod"}"'
  '';

  ldflags = [
    "-s"
    "-X github.com/anyproto/anytype-cli/core.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for interacting with Anytype";
    homepage = "https://github.com/anyproto/anytype-cli";
    changelog = "https://github.com/anyproto/anytype-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "anytype-cli";
    maintainers = with lib.maintainers; [
      adda
      wanderer
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
