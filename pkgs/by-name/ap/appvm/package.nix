{ lib
, buildGoModule
, fetchFromGitHub
, nix
, virt-viewer
, makeWrapper }:

let
  # Upstream patches fail with newer virt-viewer. These are own ports to the
  # newest virt-viewer version, see:
  # https://github.com/jollheef/appvm/issues/28
  virt-manager-without-menu = virt-viewer.overrideAttrs(oldAttrs: {
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
  version = "unstable-2021-12-20";

  src = fetchFromGitHub {
    owner = "jollheef";
    repo = pname;
    rev = "17f17be7846d872e7e26d5cb6759a52ea4113587";
    sha256 = "sha256-FL5olOy1KufULyqI2dJeS0OnKzC3LfPWxnia2i4f4yY=";
  };

  vendorHash = "sha256-8eU+Mf5dxL/bAMMShXvj8I1Kdd4ysBTWvgYIXwLStPI=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/appvm \
      --prefix PATH : "${lib.makeBinPath [ nix virt-manager-without-menu ]}"
  '';

  meta = with lib; {
    description = "Nix-based app VMs";
    homepage = "https://code.dumpstack.io/tools/${pname}";
    maintainers = with maintainers; [ dump_stack cab404 onny ];
    license = licenses.gpl3;
  };
}
