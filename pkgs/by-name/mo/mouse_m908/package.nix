{
  stdenv,
  lib,
  libusb1,
  installShellFiles,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mouse_m908";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "dokutan";
    repo = "mouse_m908";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sCAvjNpJYkp4G0KkDJtHOBR1vc80DZJtWR2W9gakkzQ=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ libusb1 ];

  # Uses proper nix directories rather than the ones specified in the makefile
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
      $out/share/doc \
      $out/share/doc/mouse_m908 \
      $out/lib/udev/rules.d

    cp mouse_m908 $out/bin/mouse_m908
    cp mouse_m908.rules $out/lib/udev/rules.d
    cp examples/* $out/share/doc/mouse_m908
    cp README.md $out/share/doc/mouse_m908
    cp keymap.md $out/share/doc/mouse_m908
    installManPage mouse_m908.1

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dokutan/mouse_m908";
    description = "Control various Redragon gaming mice from Linux, BSD and Haiku";
    mainProgram = "mouse_m908";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ kylelovestoad ];
  };
})
