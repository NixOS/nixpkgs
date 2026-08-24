{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-index";
  version = "0.1.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yl/acohrgP0C5w4eozNcWcpCGhmMMjFbzgHsKwXKw00=";
  };

  cargoHash = "sha256-EJbNptLskphe+xfI8oQ0DVUx6y4dO52eeuPiG6FSQbI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
    substituteInPlace command-not-found.nu \
      --subst-var out
    install -Dm555 command-not-found.nu -t $out/etc/profile.d
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bennofs
      ncfavier
    ];
    mainProgram = "nix-index";
  };
})
