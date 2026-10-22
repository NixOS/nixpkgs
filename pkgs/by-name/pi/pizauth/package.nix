{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
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

  cargoPatches = [
    # TODO: Remove once included upstream.
    (fetchpatch2 {
      name = "platform-verifier-support.patch";
      url = "https://github.com/ltratt/pizauth/commit/7baf8abd94c66a102ad2a5e587b1e46dcf48ec5c.patch?full_index=1";
      hash = "sha256-/Q96fvfVT85v3/iXVQdGvGrbZPamDg8oEa/3/84Anhw=";
    })
    # TODO: Remove once upstream updates or drops webpki-roots, see:
    # https://github.com/ltratt/pizauth/issues/103
    ./update-webpki.patch
  ];

  cargoHash = "sha256-juqUaoF6HrD+Chrtucz3Mfnm1CIpEnpMdHexjdaRcbk=";

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
