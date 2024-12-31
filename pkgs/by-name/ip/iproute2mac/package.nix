{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
  makeWrapper,
  python3,
}:

stdenv.mkDerivation rec {
  version = "1.5.4";
  pname = "iproute2mac";

  src = fetchFromGitHub {
    owner = "brona";
    repo = "iproute2mac";
    rev = "v${version}";
    hash = "sha256-hmSqJ2gc0DOXUuFrp1ZG8usjFdo07zjV/1JLs5r/E04=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace src/iproute2mac.py \
      --replace-fail /sbin/ifconfig ${darwin.network_cmds}/bin/ifconfig \
      --replace-fail /sbin/route ${darwin.network_cmds}/bin/route \
      --replace-fail /usr/sbin/netstat ${darwin.network_cmds}/bin/netstat \
      --replace-fail /usr/sbin/ndp ${darwin.network_cmds}/bin/ndp \
      --replace-fail /usr/sbin/arp ${darwin.network_cmds}/bin/arp \
      --replace-fail /usr/sbin/networksetup ${darwin.network_cmds}/bin/networksetup
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    install -D -m 755 src/iproute2mac.py $out/libexec/iproute2mac.py
    install -D -m 755 src/ip.py $out/libexec/ip
    install -D -m 755 src/bridge.py $out/libexec/bridge
    makeWrapper $out/libexec/ip $out/bin/ip
    makeWrapper $out/libexec/bridge $out/bin/bridge

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/brona/iproute2mac";
    description = "CLI wrapper for basic network utilites on Mac OS X inspired with iproute2 on Linux systems - ip command";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jiegec ];
    platforms = lib.platforms.darwin;
  };
}
