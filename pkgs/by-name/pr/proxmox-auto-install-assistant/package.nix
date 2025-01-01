{
  lib,
  fetchgit,
  rustPlatform,
  testers,
  proxmox-auto-install-assistant,
}:

rustPlatform.buildRustPackage rec {
  pname = "proxmox-auto-install-assistant";
  version = "8.2.6";

  src = fetchgit {
    url = "git://git.proxmox.com/git/pve-installer.git";
    rev = "c339618cbdcbce378bf192e01393a60903fe2b04";
    hash = "sha256-nF2FpzXeoPIB+dW92HAI+EJZuMJxlnD012Yu3hL9OvU=";
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

  passthru.tests.version = testers.testVersion { package = proxmox-auto-install-assistant; };

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
