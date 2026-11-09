{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kepubify";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = "kepubify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KotwzKKEgqw+B23g2JOP6CErnuvRvKDn+7/0SpgSS1o=";
  };

  vendorHash = "sha256-M4mZJmh+qVTJyoHSpNgjBJFwQhQf+w3/hZ8N/Ebe8gU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pgaskin/kepubify/v${lib.versions.major finalAttrs.version}/internal.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zowoq ];
    mainProgram = "kepubify";
  };
})
