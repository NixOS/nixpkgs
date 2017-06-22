{ fetchurl, stdenv, perl, makeWrapper
, iproute, acpi, sysstat, xset, playerctl
, cmus, openvpn, lm_sensors, alsaUtils
, scripts ? [ "bandwidth" "battery" "cpu_usage" "disk" "iface"
              "keyindicator" "load_average" "mediaplayer" "memory"
	            "openvpn" "temperature" "volume" "wifi" ]
}:

with stdenv.lib;

let
  perlscripts = [ "battery" "cpu_usage" "keyindicator"
                  "mediaplayer" "openvpn" "temperature" ];
  contains_any = l1: l2: 0 < length( intersectLists l1 l2 );

in
stdenv.mkDerivation rec {
  name = "i3blocks-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/vivien/i3blocks/releases/download/${version}/${name}.tar.gz";
    sha256 = "c64720057e22cc7cac5e8fcd58fd37e75be3a7d5a3cb8995841a7f18d30c0536";
  };

  buildFlags = "SYSCONFDIR=/etc all";
  installFlags = "PREFIX=\${out} VERSION=${version}";

  buildInputs = optional (contains_any scripts perlscripts) perl;
  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/libexec/i3blocks/bandwidth \
      --prefix PATH : ${makeBinPath (optional (elem "bandwidth" scripts) iproute)}
    wrapProgram $out/libexec/i3blocks/battery \
      --prefix PATH : ${makeBinPath (optional (elem "battery" scripts) acpi)}
    wrapProgram $out/libexec/i3blocks/cpu_usage \
      --prefix PATH : ${makeBinPath (optional (elem "cpu_usage" scripts) sysstat)}
    wrapProgram $out/libexec/i3blocks/iface \
      --prefix PATH : ${makeBinPath (optional (elem "iface" scripts) iproute)}
    wrapProgram $out/libexec/i3blocks/keyindicator \
      --prefix PATH : ${makeBinPath (optional (elem "keyindicator" scripts) xset)}
    wrapProgram $out/libexec/i3blocks/mediaplayer \
      --prefix PATH : ${makeBinPath (optionals (elem "mediaplayer" scripts) [playerctl cmus])}
    wrapProgram $out/libexec/i3blocks/openvpn \
      --prefix PATH : ${makeBinPath (optional (elem "openvpn" scripts) openvpn)}
    wrapProgram $out/libexec/i3blocks/temperature \
      --prefix PATH : ${makeBinPath (optional (elem "temperature" scripts) lm_sensors)}
    wrapProgram $out/libexec/i3blocks/volume \
      --prefix PATH : ${makeBinPath (optional (elem "volume" scripts) alsaUtils)}
  '';

  meta = {
    description = "A flexible scheduler for your i3bar blocks";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
