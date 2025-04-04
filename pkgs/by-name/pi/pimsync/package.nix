{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  sqlite,
  scdoc,
  installShellFiles,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pimsync";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "pimsync";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EHDGiyDGNr6cPj2N2cTV0f7I9vmM/WIZTsPR1f+HFIE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/6YjyKB/xOCTNZlKewddEaZ1ZN2PC5dQoP0A5If67MA=";

  PIMSYNC_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    pkg-config
    scdoc
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    sqlite
  ];

  postBuild = ''
    make man
  '';

  postInstall = ''
    installManPage target/pimsync.1 target/pimsync.conf.5 target/pimsync-migration.7
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Synchronise calendars and contacts";
    homepage = "https://git.sr.ht/~whynothugo/pimsync";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "pimsync";
  };
})
