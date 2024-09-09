{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "snpguest";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snpguest";
    rev = "v${version}";
    hash = "sha256-9TchRaZPQKAsncs+mlHvzeie9IIVZeea/LfBLXOLuNg=";
  };

  cargoHash = "sha256-1UX5GiwH38W+IgZO+0EA3M86iWMylM8fgr48DRD187A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for interacting with SEV-SNP guest environment";
    homepage = "https://github.com/virtee/snpguest";
    changelog = "https://github.com/virtee/snpguest/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "snpguest";
    platforms = [ "x86_64-linux" ];
  };
}
