{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.13.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0XmgaNDob+e5yCEFaySj++6M0uJFmP5aQjjnLJDRx14=";
  };

  cargoHash = "sha256-zNo7HI+p5grdTayXDehMwAeEq4aOPYGSPb06c4ib95s=";

  nativeBuildInputs = [
    perl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/core/oniux";
    description = "Isolate Applications over Tor using Linux Namespaces";
    maintainers = with lib.maintainers; [ tnias ];
    platforms = lib.platforms.linux;
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    mainProgram = "oniux";
  };
})
