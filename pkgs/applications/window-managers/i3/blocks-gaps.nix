{ fetchFromGitHub, lib, stdenv, perl, makeWrapper
, iproute2, acpi, sysstat, alsa-utils
, scripts ? [ "bandwidth" "battery" "cpu_usage" "disk" "iface"
              "load_average" "memory" "volume" "wifi" ]
}:

let
  perlscripts = [ "battery" "cpu_usage" "openvpn" "temperature" ];
  contains_any = l1: l2: 0 < lib.length( lib.intersectLists l1 l2 );

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

  buildInputs = lib.optional (contains_any scripts perlscripts) perl;
  nativeBuildInputs = [ makeWrapper ];

  postFixup = lib.optionalString (lib.elem "bandwidth" scripts) ''
    wrapProgram $out/libexec/i3blocks/bandwidth \
      --prefix PATH : ${lib.makeBinPath [ iproute2 ]}
  '' + lib.optionalString (lib.elem "battery" scripts) ''
    wrapProgram $out/libexec/i3blocks/battery \
      --prefix PATH : ${lib.makeBinPath [ acpi ]}
  '' + lib.optionalString (lib.elem "cpu_usage" scripts) ''
    wrapProgram $out/libexec/i3blocks/cpu_usage \
      --prefix PATH : ${lib.makeBinPath [ sysstat ]}
  '' + lib.optionalString (lib.elem "iface" scripts) ''
    wrapProgram $out/libexec/i3blocks/iface \
      --prefix PATH : ${lib.makeBinPath [ iproute2 ]}
  '' + lib.optionalString (lib.elem "volume" scripts) ''
    wrapProgram $out/libexec/i3blocks/volume \
      --prefix PATH : ${lib.makeBinPath [ alsa-utils ]}
  '';

  meta = with lib; {
    description = "A flexible scheduler for your i3bar blocks -- this is a fork to use with i3-gaps";
    homepage = "https://github.com/Airblader/i3blocks-gaps";
    license = licenses.gpl3;
    maintainers = with maintainers; [ carlsverre ];
    platforms = platforms.linux;
  };
}
