{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-04JywbJ//qgA56/5C4DZOliryZCnO0K3/0lyevFz7hk=";
  };

  cargoHash = "sha256-a0hV4q288IWFC1a1jTvgkXAVyKGm8OnsRHwShnQjywI=";

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
