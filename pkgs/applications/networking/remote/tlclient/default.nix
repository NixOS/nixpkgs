{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, alsa-lib
, libX11
, pcsclite
}:
let
  tlclient-png = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/tlclient.png?h=tlclient&id=fd126edd54a012caa8c9ce47ab8d7fb25e982e74";
    sha256 = "12i0wc4a8r69kwcdj0kjidwvmwhpb8jcwsqxw9dl5vm1gdqxyz5v";
    name = "tlclient-png";
  };
in
stdenv.mkDerivation rec {
  pname = "tlclient";
  version = "4.13.0-2172";

  src = fetchurl {
    # x86_64 arch tarball
    url = "https://www.cendio.com/downloads/clients/tl-${version}-client-linux-dynamic-x86_64.tar.gz";
    sha256 = "1mpigdd3abcypwjiwql2lrvpw3r6074czsxyanndnvfzy7xhc8ac";
  };

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems ];
  propagatedBuildInputs = [ alsa-lib libX11 pcsclite ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 "lib/tlclient/EULA.txt" "$out/share/licenses/tlclient/EULA.txt"
    install -m644 "lib/tlclient/open_source_licenses.txt" "$out/share/licenses/tlclient/open_source_licenses.txt"
    cp -R lib "$out/"

    install -Dm644 "etc/tlclient.conf" "$out/etc/tlclient.conf"
    install -Dm755 "bin/tlclient" "$out/bin/tlclient"
    install -Dm755 "bin/tlclient-openconf" "$out/bin/tlclient-openconf"

    install -Dm644 "${tlclient-png}" "$out/share/tlclient/tlclient.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "ThinLinc Client";
      name = "tlclient";
      exec = "tlclient";
      icon = "tlclient";
      comment = meta.description;
      type = "Application";
      categories = "Network;RemoteAccess;";
    })
  ];

  meta = with lib; {
    description = "Linux remote desktop client built on open source technology";
    license = {
      fullName = "Cendio End User License Agreement 3.2";
      url = "https://www.cendio.com/thinlinc/docs/legal/eula";
      free = false;
    };
    homepage = "https://www.cendio.com/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
