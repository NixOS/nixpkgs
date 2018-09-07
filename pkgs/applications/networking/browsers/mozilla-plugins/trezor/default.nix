{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation {
  name = "TREZOR-bridge-1.0.5";

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url    = https://mytrezor.com/data/plugin/1.0.5/browser-plugin-trezor_1.0.5_amd64.deb;
        sha256 = "0097h4v88yca4aayzprrh4pk03xvvj7ncz2mi83chm81gsr2v67z";
      }
    else
      fetchurl {
        url    = https://mytrezor.com/data/plugin/1.0.5/browser-plugin-trezor_1.0.5_i386.deb;
        sha256 = "0xzbq78s3ivg00f0bj6gyjgf47pvjx2l4mm05jjmdar60bf1xr1n";
      };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = "${dpkg}/bin/dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d/ $out/lib/mozilla/plugins
    cp ./lib/udev/rules.d/51-trezor-udev.rules $out/etc/udev/rules.d/
    cp ./usr/lib/mozilla/plugins/npBitcoinTrezorPlugin.so $out/lib/mozilla/plugins
  '';

  meta = with stdenv.lib;
    { description = "Plugin for browser to TREZOR device communication";
      homepage = https://mytrezor.com;
      license = licenses.unfree;
      maintainers = with maintainers; [ ehmry ];
      # Download URL, .deb content & hash (yikes) changed, not version.
      # New archive doesn't contain any Mozilla plugin at all.
      broken = true;
      platforms = platforms.linux;
   };

}
