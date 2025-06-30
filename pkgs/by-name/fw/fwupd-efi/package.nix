{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  gnu-efi,
  python3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwupd-efi";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = "fwupd-efi";
    rev = "${finalAttrs.version}";
    hash = "sha256-PcVqnnFrxedkhYgm+8EUF2I65R5gTXqbVrk69Pw1m1g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.pefile
  ];

  buildInputs = [
    gnu-efi
  ];

  postPatch = ''
    patchShebangs \
      efi/generate_binary.py \
      efi/generate_sbat.py
  '';

  mesonFlags = [
    "-Defi-includedir=${gnu-efi}/include/efi"
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-ldsdir=${gnu-efi}/lib"
    "-Defi_sbat_distro_id=nixos"
    "-Defi_sbat_distro_summary=NixOS"
    "-Defi_sbat_distro_pkgname=${finalAttrs.pname}"
    "-Defi_sbat_distro_version=${finalAttrs.version}"
    "-Defi_sbat_distro_url=https://search.nixos.org/packages?channel=unstable&show=fwupd-efi&from=0&size=50&sort=relevance&query=fwupd-efi"
    "-Dgenpeimg=disabled"
  ];

  meta = with lib; {
    homepage = "https://fwupd.org/";
    maintainers = [ ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
})
