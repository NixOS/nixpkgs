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

rustPlatform.buildRustPackage rec {
  pname = "pimsync";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "pimsync";
    rev = "v${version}";
    hash = "sha256-IY+5n4sWlOzD29ERQ7CEsES0BizV68qnZt5NwCjLlfY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QRbjv8k7JEktHjfwJGwVReu9lynB817edsyClOoAwoA=";

  PIMSYNC_VERSION = version;

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
}
