{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssh,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxish";
  version = "0.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "djc";
    repo = "oxish";
    tag = finalAttrs.version;
    hash = "sha256-QARW2KRrr/7UBgcj8YNYP07aaMOQqApfBw6O+XKcJ7U=";
  };

  cargoHash = "sha256-QgJZKr5U0O6Oi8DlHKLCZDoGbM07ywva288jlvtShVk=";

  nativeCheckInputs = [
    openssh
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, memory-safe SSH server written in Rust";
    homepage = "https://github.com/djc/oxish";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
