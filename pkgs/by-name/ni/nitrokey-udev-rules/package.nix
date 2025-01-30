{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nitrokey-udev-rules";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-udev-rules";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uq1+YQg+oe5UFphpy1AdxEYaPFyRle6ffYOPoU6Li28=";
  };

  installPhase = ''
    install -D 41-nitrokey.rules -t $out/etc/udev/rules.d
  '';

  meta = with lib; {
    description = "udev rules for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-udev-rules";
    license = [ licenses.cc0 ];
    maintainers = with maintainers; [
      frogamic
      robinkrahl
    ];
  };
})
