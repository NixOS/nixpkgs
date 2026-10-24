{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pam,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pam-ssh-agent";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "nresare";
    repo = "pam-ssh-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-33dM0+FTdT9IMiE4rWr76c7f3ADZiKoYNTJhW4DoKwY=";
  };

  cargoHash = "sha256-eFKUKbraKvCuZiCCT0FURNqlJd8UPGr/+gO5hCfNj90=";

  buildInputs = [
    pam
  ];

  # tests are partially broken due to hardcoded paths
  # (doesn't seem worth the effort to introduce patches)
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A PAM module that authenticates using the ssh-agent";
    homepage = "https://github.com/nresare/pam-ssh-agent";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [
      tmarkus
    ];
    platforms = lib.platforms.linux;
  };
})
