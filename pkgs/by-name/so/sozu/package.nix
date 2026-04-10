{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  nix-update-script,
  testers,
  sozu,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sozu";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = "sozu";
    rev = finalAttrs.version;
    hash = "sha256-a/Pna2l1gRv4kxIyGUuUHlN+lIQemGjZXwM65Ccc24Y=";
  };

  cargoHash = "sha256-9ZmlUUdtVAvri9v+EJb6vRQ7Yc3FjRwU5I5Xe8je9/c=";

  nativeBuildInputs = [ protobuf ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sozu;
      command = "sozu --version";
      version = "${finalAttrs.version}";
    };
  };

  meta = {
    description = "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "sozu";
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.hostPlatform.isx86_64;
  };
})
