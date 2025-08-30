{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ramparts";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "getjavelin";
    repo = "ramparts";
    tag = finalAttrs.version;
    hash = "sha256-2mv/FWTbDxzLt1ArcbWje+pjErEZ8S5U+KDGxm4f6ao=";
  };

  cargoHash = "sha256-vJbBK7KqrGJQ0zFGXXMCBKw3Q+UmLFeDP7dmOkmc8cs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "mcp (model context protocol) scanner";
    longDescription = ''
      Mcp scan that scans any mcp server for indirect attack vectors
      and security or configuration vulnerabilities.
    '';
    homepage = "https://github.com/getjavelin/ramparts";
    changelog = "https://github.com/getjavelin/ramparts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ramparts";
  };
})
