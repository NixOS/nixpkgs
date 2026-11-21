{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  scdoc,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acme-redirect";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "acme-redirect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ksx9uII9xBj6ZhBEXlgf042eyiNhoFm2zhaCl+uJNG4=";
  };

  cargoHash = "sha256-cdiDQEZkqMRkEmCrZTaaFtcqkLgdPqhdqFUoQcZoGj4=";

  nativeBuildInputs = [
    pkg-config
    scdoc
    installShellFiles
  ];

  buildInputs = [ openssl ];

  postBuild = "make docs";

  postInstall = ''
    pushd contrib/docs
    installManPage acme-redirect.1 acme-redirect.d.5 acme-redirect.conf.5
    popd

    # see nixos option systemd.packages
    systemdUnitsTarget=$out/lib/systemd/system

    # see nixos option systemd.tmpfiles.packages
    systemdTmpfilesTarget=$out/lib/tmpfiles.d

    # no nixos option systemd.sysusers.packages exists yet
    systemdSysusersTarget=$out/lib/sysusers.d

    pushd contrib/systemd
    install -Dm644 -t  $systemdUnitsTarget acme-redirect.service acme-redirect-renew.service acme-redirect-renew.timer
    pushd $systemdUnitsTarget
    substituteInPlace  acme-redirect.service acme-redirect-renew.service \
      --replace-fail '/usr/bin/acme-redirect' $out/bin/acme-redirect
    popd

    install -Dm644 acme-redirect.sysusers $systemdSysusersTarget/acme-redirect.conf
    install -Dm644 acme-redirect.tmpfiles $systemdTmpfilesTarget/acme-redirect.conf
    popd
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Tiny http daemon that answers acme challenges and redirects everything else to https";
    changelog = "https://github.com/kpcyrd/acme-redirect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "acme-redirect";
    maintainers = [ lib.maintainers.haansn08 ];
  };

})
