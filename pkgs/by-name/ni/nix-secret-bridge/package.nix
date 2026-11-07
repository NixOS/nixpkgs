{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  sops,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-secret-bridge";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Mutasem-mk4";
    repo = "nix-secret-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5HuQfJWO9zUz9qYhaEtoTWZJIZWupXHy87osg7FMyqg=";
  };

  cargoHash = "sha256-F7/9++8i03Ku0/Kbfu/eP6q91IBO5oWJwU8ZEZc8GDU=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/nix-secret-bridge" \
      --prefix PATH : ${lib.makeBinPath [ sops ]}
  '';

  __structuredAttrs = true;

  meta = {
    description = "Bootstrap secret bridge for NixOS disko LUKS keys";
    longDescription = ''
      nix-secret-bridge decrypts age or SOPS-encrypted bootstrap secrets in
      the installer environment and exposes the plaintext only on tmpfs so
      disko can consume LUKS keys before the target NixOS system has booted.
    '';
    homepage = "https://github.com/Mutasem-mk4/nix-secret-bridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers."mutasem-mk4" ];
    mainProgram = "nix-secret-bridge";
    platforms = lib.platforms.linux;
  };
})
