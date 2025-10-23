{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix,
  virt-viewer,
  makeWrapper,
}:

let
  # Upstream patches fail with newer virt-viewer. These are own ports to the
  # newest virt-viewer version, see:
  # https://github.com/jollheef/appvm/issues/28
  virt-manager-without-menu = virt-viewer.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      ./0001-Remove-menu-bar.patch
      ./0002-Do-not-grab-keyboard-mouse.patch
      ./0003-Use-name-of-appvm-applications-as-a-title.patch
      ./0004-Use-title-application-name-as-subtitle.patch
    ];
  });
in
buildGoModule rec {
  pname = "appvm";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "jollheef";
    repo = "appvm";
    tag = "v${version}";
    sha256 = "sha256-n+YputGiNWSOYbwes/rjz0h3RWZONDTc8+LDc0La/KU=";
  };

  vendorHash = "sha256-8eU+Mf5dxL/bAMMShXvj8I1Kdd4ysBTWvgYIXwLStPI=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/appvm \
      --prefix PATH : "${
        lib.makeBinPath [
          nix
          virt-manager-without-menu
        ]
      }"
  '';

  meta = {
    description = "Nix-based app VMs";
    homepage = "https://code.dumpstack.io/tools/appvm";
    maintainers = with lib.maintainers; [
      dump_stack
      cab404
      onny
    ];
    license = lib.licenses.gpl3;
  };
}
