{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage {
  pname = "proxmox-auto-install-assistant";
  version = "9.0.7";

  src = fetchgit {
    url = "git://git.proxmox.com/git/pve-installer.git";
    rev = "cfcaceacb797bfdbff8c7e8fed76e56642390b20";
    hash = "sha256-tXwNuT25GzQhdDtYiiQKPu6EPZQffUOZhBqkLZK/+DY=";
  };

  postPatch = ''
    rm -v .cargo/config.toml
    cp -v ${./Cargo.lock} Cargo.lock
    # pre-generated using `make locale-info.json`
    # depends on non-packaged perl modules and debian-specific files
    cp -v ${./locale-info.json} locale-info.json
  '';

  buildAndTestSubdir = "proxmox-auto-install-assistant";

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl.dev ];

  postFixup = ''
    # these libraries are not actually necessary, only linked in by cargo
    # through crate dependencies (unfortunately)
    patchelf \
      --remove-needed libcrypto.so.3 \
      --remove-needed libssl.so.3 \
      $out/bin/proxmox-auto-install-assistant
    patchelf --shrink-rpath $out/bin/proxmox-auto-install-assistant
  '';

  disallowedReferences = [ openssl.out ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool to prepare a Proxmox installation ISO for automated installations";
    longDescription = ''
      This tool can be used to prepare a Proxmox installation ISO for automated installations.
      Additional uses are to validate the format of an answer file or to test match filters and
      print information on the properties to match against for the current hardware.
    '';
    homepage = "https://pve.proxmox.com/wiki/Automated_Installation";
    changelog = "https://git.proxmox.com/?p=pve-installer.git;a=blob;f=debian/changelog";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.linux;
    mainProgram = "proxmox-auto-install-assistant";
  };
}
