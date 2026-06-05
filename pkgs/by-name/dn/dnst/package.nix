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
  version = "0.2.0-alpha2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OpyOnBddbIdnJLchY5y2oMqK5JSXCTF8cC5KstJ7pnc=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-y048tMh5wBjAB7I8FK3pETn0j9S/h893JZb9sbOBdbo=";

  postInstall = ''
    mkdir -p $out/libexec
    mv $out/bin/ldns $out/libexec
    for tool in key2ds keygen notify nsec3-hash signzone; do
      makeWrapper $out/libexec/ldns $out/bin/ldns-$tool --add-flag ldns-$tool
    done

    installManPage doc/manual/build/man/*.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolset to assist DNS operators with zone and nameserver maintenance";
    mainProgram = "dnst";
    homepage = "https://nlnetlabs.nl/projects/domain/dnst/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
