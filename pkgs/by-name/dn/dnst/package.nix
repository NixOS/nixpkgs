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
  version = "0.3.0-alpha";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rXrjHxUJI+D6lLCAVEGr4OGE60eKhxvVe56YV0TFqM8=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-70F8vajZSLkBS1YWFVSXhPwYGM1WHYUaGps4fhtRYkk=";

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
    changelog = "https://github.com/NLnetLabs/dnst/blob/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
