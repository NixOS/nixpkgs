{ fetchFromGitHub, stdenv, perl, makeWrapper
, iproute, acpi, sysstat, alsaUtils
, scripts ? [ "bandwidth" "battery" "cpu_usage" "disk" "iface"
              "load_average" "memory" "volume" "wifi" ]
}:

with stdenv.lib;

let
  perlscripts = [ "battery" "cpu_usage" "openvpn" "temperature" ];
  contains_any = l1: l2: 0 < length( intersectLists l1 l2 );

in
stdenv.mkDerivation rec {
  pname = "i3blocks-gaps";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "i3blocks-gaps";
    rev = "4cfdf93c75f729a2c96d471004d31734e923812f";
    sha256 = "0v9307ij8xzwdaxay3r75sd2cp453s3qb6q7dy9fks2p6wwqpazi";
  };

  makeFlags = [ "all" ];
  installFlags = [ "PREFIX=\${out}" "VERSION=${version}" ];

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
    wrapProgram $out/libexec/i3blocks/volume \
      --prefix PATH : ${makeBinPath (optional (elem "volume" scripts) alsaUtils)}
  '';

  meta = with stdenv.lib; {
    description = "A flexible scheduler for your i3bar blocks -- this is a fork to use with i3-gaps";
    homepage = https://github.com/Airblader/i3blocks-gaps;
    license = licenses.gpl3;
    maintainers = with maintainers; [ carlsverre ];
    platforms = platforms.linux;
  };
}
