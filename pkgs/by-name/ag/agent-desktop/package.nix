{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  zlib,
}:

rustPlatform.buildRustPackage {
  pname = "agent-desktop";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-desktop";
    rev = "v1.3.1";
    hash = "sha256-/SZ2AR1ww8pcUeffEk1Np24M3roiS1yXNQyCle82T5Q=";
  };

  cargoHash = "sha256-VlPyMlUtTm7v3AHbCiippZLAOGM4yH3+Oc2B9ZAOJ1g=";

  cargoBuildFlags = [
    "-p"
    "agent-desktop"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-p"
    "agent-desktop-macos"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-p"
    "agent-desktop-linux"
  ];

  # Workspace tests select platform-specific crates and live desktop checks.
  doCheck = false;
  buildInputs = [ zlib ];
  patches = [ ./deprecated-declaration.patch ];
  strictDeps = true;
  __structuredAttrs = true;

  postInstall = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/agent-desktop-macos-helper $out/bin/agent-desktop-macos-helper
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/agent-desktop-linux-clipboard-owner $out/bin/agent-desktop-linux-clipboard-owner
    ''}
  '';

  meta = {
    description = "Computer use CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-desktop";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.NikoPit ];
    mainProgram = "agent-desktop";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
