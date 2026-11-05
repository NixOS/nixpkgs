{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.15.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MEw5UIPl2xqMcf5IOhKBf0LZam5e2g/iukq+ds/f6Bs=";
  };

  cargoHash = "sha256-Hx6BA+ynbPBtgB4jR9YSFJ++8ndDuRD6CFFsIzh9iAA=";

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
