{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-28y1/FPO997rnsAJS5o7aRSskYkXgH7kMdV+Dbj/1dI=";
  };

  cargoHash = "sha256-T+r3XVa4EZ9g+9iYqxoO2yLmTucA89UqeYO92TdoiSA=";

  nativeBuildInputs = [
    perl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/core/oniux";
    description = "Isolate Applications over Tor using Linux Namespaces";
    maintainers = with lib.maintainers; [ tnias ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oniux";
  };
})
