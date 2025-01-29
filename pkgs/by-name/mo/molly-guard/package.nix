{ lib, stdenv, fetchurl, dpkg, busybox, systemd }:

stdenv.mkDerivation rec {
  pname = "molly-guard";
  version = "0.7.2";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/molly-guard_${version}_all.deb";
    sha256 = "1k6b1hn8lc4rj9n036imsl7s9lqj6ny3acdhnbnamsdkkndmxrw7";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    sed -i "s|/lib/molly-guard|${systemd}/sbin|g" lib/molly-guard/molly-guard
    sed -i "s|run-parts|${busybox}/bin/run-parts|g" lib/molly-guard/molly-guard
    sed -i "s|/etc/molly-guard/|$out/etc/molly-guard/|g" lib/molly-guard/molly-guard
    cp -r ./ $out/
  '';

  postFixup = ''
    for modus in init halt poweroff reboot runlevel shutdown telinit; do
       ln -sf $out/lib/molly-guard/molly-guard $out/bin/$modus;
    done;
  '';

  meta = with lib; {
    description = "Attempts to prevent you from accidentally shutting down or rebooting machines";
    homepage    = "https://salsa.debian.org/debian/molly-guard";
    license     = licenses.artistic2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ DerTim1 ];
    priority    = -10;
  };
}
