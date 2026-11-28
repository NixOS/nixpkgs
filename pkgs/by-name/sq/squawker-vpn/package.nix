{
  lib,
  stdenv,
  fetchurl,
  dpkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squawker-vpn";
  version = "0.10.1";

  src = fetchurl {
    url = "https://squawker-vpn.vm.tryhackme.com/latest/squawker-vpn_${finalAttrs.version}_amd64.deb";
    hash = "sha256-vs8Dcb6JVqD09TP2OqLewLRq742l88pue4CFSoGw+Ec=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    dpkg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./{usr,lib} $out/

    mkdir -p $out/bin
    mv $out/usr/bin/squawker-vpn $out/bin/
    substituteInPlace $out/usr/share/applications/squawker-vpn.desktop --replace "/usr/bin/squawker-vpn" "$out/bin/squawker-vpn"

    runHook postInstall
  '';

  meta = {
    homepage = "https://tryhackme.com/manage-account/access";
    description = "Squawker VPN is a VPN application that helps you connect to THM VPN";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mandar1jn ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
    ];
  };
})
