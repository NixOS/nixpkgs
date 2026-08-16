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

let
  installer_src = fetchgit {
    url = "git://git.proxmox.com/git/pve-installer.git";
    rev = "32afcd4cd534d8e2f99ae76aa0234a0a5c697ba9";
    hash = "sha256-mlTSkBr5glkCr21l2Z1GFICLOn02IOWjMKBy8BvkSzc=";
  };

  proxmox_crates_src = fetchgit {
    url = "git://git.proxmox.com/git/proxmox.git";
    rev = "b9bc28082f820dbf88f8dcc02ba2250fc999f9d0";
    name = "proxmox";
    hash = "sha256-NPJi2BzANBfQx995lzIcgCKthWSv+8NeD8zrYnoMye8=";
  };
in
rustPlatform.buildRustPackage {
  pname = "proxmox-auto-install-assistant";
  version = "9.2.5";

  srcs = [
    installer_src
    proxmox_crates_src
  ];

  sourceRoot = installer_src.name;

  postPatch = ''
    rm -v .cargo/config.toml
    cp -v ${./Cargo.lock} Cargo.lock
    chmod u+w Cargo.lock
    # pre-generated using `make locale-info.json`
    # depends on non-packaged perl modules and debian-specific files
    cp -v ${./locale-info.json} locale-info.json

    # add necessary crates.io patches to redirect to checked-out repo
    cat <<EOF >>Cargo.toml
    proxmox-network-types.path = "../proxmox/proxmox-network-types"
    proxmox-installer-types.path = "../proxmox/proxmox-installer-types"
    proxmox-sys.path = "../proxmox/proxmox-sys"
    EOF
  '';

  buildAndTestSubdir = "proxmox-auto-install-assistant";

  cargoLock.lockFile = ./Cargo.lock;

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
