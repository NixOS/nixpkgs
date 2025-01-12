{
  lib,
  fetchgit,
  rustPlatform,
  testers,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "proxmox-auto-install-assistant";
  version = "8.3.3";

  src = fetchgit {
    url = "git://git.proxmox.com/git/pve-installer.git";
    rev = "cf6df4a23491071d207dcc8b00af8ddf310ae0b0";
    hash = "sha256-n4mn8VF84QyJiUNubgoxkbMEbuyj8n5KeIdVB3Xz5iY=";
  };

  postPatch = ''
    rm -v .cargo/config.toml
    cp -v ${./Cargo.lock} Cargo.lock
    # fix up hard-coded version number to match that of the debian package
    substituteInPlace proxmox-auto-install-assistant/Cargo.toml \
      --replace-fail 'version = "0.1.0"' 'version = "${version}"'
  '';

  buildAndTestSubdir = "proxmox-auto-install-assistant";

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl.dev ];

  postFixup = ''
    # openssl is not actually necessary, only pulled in through a feature (unfortunately)
    patchelf --remove-needed libssl.so.3 $out/bin/proxmox-auto-install-assistant
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Tool to prepare a Proxmox installation ISO for automated installations";
    longDescription = ''
      This tool can be used to prepare a Proxmox installation ISO for automated installations.
      Additional uses are to validate the format of an answer file or to test match filters and
      print information on the properties to match against for the current hardware
    '';
    homepage = "https://pve.proxmox.com/wiki/Automated_Installation";
    changelog = "https://git.proxmox.com/?p=pve-installer.git;a=blob;f=debian/changelog";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.linux;
    mainProgram = "proxmox-auto-install-assistant";
  };
}
