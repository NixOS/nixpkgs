{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  installShellFiles,
  makeWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnst";
  version = "0.2.0-alpha3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Sgj2OZptG/bMsuYdGfaaY62qh4uUyxdbit6vpWWm9w=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-8pzf4GeBJbqIZf6KAqROEAvFAqtf6XLODWhS3RVfpAQ=";

  postInstall = ''
    mkdir -p $out/libexec
    mv $out/bin/ldns $out/libexec
    for tool in key2ds keygen notify nsec3-hash signzone; do
      makeWrapper $out/libexec/ldns $out/bin/ldns-$tool --add-flag ldns-$tool
    done

    installManPage doc/manual/build/man/*.1
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Toolset to assist DNS operators with zone and nameserver maintenance";
    mainProgram = "dnst";
    homepage = "https://nlnetlabs.nl/projects/domain/dnst/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
