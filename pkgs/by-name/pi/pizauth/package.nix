{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  enableSystemd ? stdenv.hostPlatform.isLinux,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-VL58v/mBwFwDmF4Xg43bzitcBCsPsEwEaLKqV5X9rpg=";
  };

  cargoHash = "sha256-pxzPcieUXE3VOyGNDaeDHUQPayRDZXpW57VWMejlZ4k=";

  buildFeatures = lib.optionals enableSystemd [
    "systemd"
  ];

  preConfigure = ''
    substituteInPlace lib/systemd/user/pizauth.service \
      --replace-fail /usr/bin/ ''${!outputBin}/bin/
    # Upstream's Makefile uses target/release/pizauth as a Makefile target that
    # the `install` target depends upon. Nixpkgs' cargoBuildHook defaults to
    # using the explicit `--target @rustcTargetSpec@` flag, so that the
    # executable always ends up in
    # `target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release`. To make the
    # Makefile not run cargo build again, we use this substitution.
    substituteInPlace Makefile \
      --replace-fail target/release target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release
  '';

  postInstall = ''
    make PREFIX=$out install ${lib.optionalString enableSystemd "install-systemd"}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=pizauth-(.*)" ]; };

  meta = {
    description = "Command-line OAuth2 authentication daemon";
    homepage = "https://github.com/ltratt/pizauth";
    changelog = "https://github.com/ltratt/pizauth/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      moraxyc
      doronbehar
    ];
    mainProgram = "pizauth";
  };
})
