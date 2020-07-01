{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils
, openvpn, python, dialog, wget, update-resolv-conf }:

let
  expectedUpdateResolvPath = "/etc/openvpn/update-resolv-conf";
  actualUpdateResolvePath = "${update-resolv-conf}/libexec/openvpn/update-resolv-conf";

in stdenv.mkDerivation rec {
  name = "protonvpn-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "protonvpn-cli";
    rev = "v${version}";
    sha256 = "0xvflr8zf267n3dv63nkk4wjxhbckw56sqmyca3krf410vrd7zlv";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    substituteInPlace protonvpn-cli.sh \
      --replace ${expectedUpdateResolvPath} ${actualUpdateResolvePath} \
      --replace \$UID 0 \
      --replace /etc/resolv.conf /dev/null \
      --replace \
        "  echo \"Connecting...\"" \
        "  sed -ri 's@${expectedUpdateResolvPath}@${actualUpdateResolvePath}@g' \"\$openvpn_config\"; echo \"Connecting...\""
    cp protonvpn-cli.sh "$out/bin/protonvpn-cli"
    wrapProgram $out/bin/protonvpn-cli \
      --prefix PATH : ${lib.makeBinPath [ coreutils openvpn python dialog wget update-resolv-conf ]}
    ln -s "$out/bin/protonvpn-cli" "$out/bin/pvpn"
  '';

  meta = with stdenv.lib; {
    description = "ProtonVPN Command-Line Tool";
    homepage = "https://github.com/ProtonVPN/protonvpn-cli";
    maintainers = with maintainers; [ caugner ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
