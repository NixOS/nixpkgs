{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ys6RjLyfhoAIiIlf8pv971txPubobY627jhk84HZhsw=";
  };

  cargoHash = "sha256-4sXCZ2P4HFsW3g/CSIB2gwBMSddNXzdIav1tSWWOO9A=";

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
