{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  openssl,
  libxcrypt,
  libisoburn,
  versionCheckHook,
}:

rustPlatform.buildRustPackage {
  pname = "proxmox-auto-install-assistant";
  version = "9.1.6";

  src = fetchgit {
    url = "git://git.proxmox.com/git/pve-installer.git";
    rev = "eab66c74a79663008ab12990bd27195a8d5c4204";
    hash = "sha256-nMyi3GfdQv/L05hpReSIoFrvmpbs4+5t/lUXXgP0bUs=";
  };

  postPatch = ''
    rm -v .cargo/config.toml
    cp -v ${./Cargo.lock} Cargo.lock
    chmod u+w Cargo.lock
    # pre-generated using `make locale-info.json`
    # depends on non-packaged perl modules and debian-specific files
    cp -v ${./locale-info.json} locale-info.json
  '';

  buildAndTestSubdir = "proxmox-auto-install-assistant";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "proxmox-io-1.2.1" = "sha256-1F5PJKJ/Ys1EfFPqpP08pRiiTKOAt9IHZ/fbeYxH7SQ=";
      "proxmox-lang-1.5.0" = "sha256-1F5PJKJ/Ys1EfFPqpP08pRiiTKOAt9IHZ/fbeYxH7SQ=";
      "proxmox-sys-1.0.0" = "sha256-1F5PJKJ/Ys1EfFPqpP08pRiiTKOAt9IHZ/fbeYxH7SQ=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxcrypt
    openssl.dev
  ];

  propagatedBuildInputs = [ libisoburn ];

  postFixup = ''
    # these libraries are not actually necessary, only linked in by cargo
    # through crate dependencies (unfortunately)
    patchelf \
      --remove-needed libcrypto.so.3 \
      $out/bin/proxmox-auto-install-assistant
    patchelf --shrink-rpath $out/bin/proxmox-auto-install-assistant
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
