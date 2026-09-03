{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  makeWrapper,
  gawk,
  bluez,
  util-linux,
  gnugrep,
  gnused,
  coreutils,
  iproute2,
  udevCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bootmac";
  version = "0.7.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "bootmac";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GWvZUC8LKPpOWt1oCr93JHg5+W+0CCiYT63VhpSH1ko=";
  };

  nativeBuildInputs = [
    meson
    ninja
    makeWrapper
    udevCheckHook
  ];

  mesonFlags = [ "-Dsystemd_units=true" ];

  postInstall = ''
     wrapProgram $out/bin/bootmac \
       --prefix PATH : ${
         lib.makeBinPath [
           gawk
           bluez
           util-linux
           gnugrep
           gnused
           coreutils
           iproute2
         ]
       }

    substituteInPlace \
      $out/lib/systemd/system/bootmac@.service \
      $out/lib/udev/rules.d/90-bootmac-{bluetooth,wifi}.rules \
      --replace-fail /usr/bin/bootmac $out/bin/bootmac
  '';

  meta = {
    description = "Configure the MAC addresses of WLAN and Bluetooth interfaces at boot";
    mainProgram = "bootmac";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = bluez.meta.platforms;
  };
})
