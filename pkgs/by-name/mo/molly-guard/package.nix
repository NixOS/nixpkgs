{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  busybox,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "molly-guard";
  version = "0.8.5";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/molly-guard_${finalAttrs.version}_all.deb";
    hash = "sha256-9CQNU+5OPmCPTN3rotyJPLcvI8eo5WJQqx0OaI7Wox4=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    sed -i "s|/lib/molly-guard|${systemd}/sbin|g" usr/lib/molly-guard/molly-guard
    sed -i "s|run-parts|${busybox}/bin/run-parts|g" usr/lib/molly-guard/molly-guard
    sed -i "s|/etc/molly-guard/|$out/etc/molly-guard/|g" usr/lib/molly-guard/molly-guard
    cp -r usr $out

    runHook postInstall
  '';

  postFixup = ''
    for modus in init halt poweroff reboot runlevel shutdown telinit; do
       ln -sf $out/lib/molly-guard/molly-guard $out/bin/$modus;
    done;
  '';

  meta = {
    description = "Attempts to prevent you from accidentally shutting down or rebooting machines";
    homepage = "https://salsa.debian.org/debian/molly-guard";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ DerTim1 ];
    priority = -10;
  };
})
