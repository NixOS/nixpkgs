{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  glib,
  gtk3,
  iw,
  makeWrapper,
  qrencode,
  hostapd,
  getopt,
  dnsmasq,
  iproute2,
  flock,
  iptables,
  gawk,
  coreutils,
  gnugrep,
  gnused,
  kmod,
  networkmanager,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linux-wifi-hotspot";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "lakinduakash";
    repo = "linux-wifi-hotspot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+WHYWQ4EyAt+Kq0LHEgC7Kk5HpIqThz6W3PIdW8Wojk=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    makeWrapper
    qrencode
    hostapd
  ];

  buildInputs = [
    glib
    gtk3
  ];

  outputs = [ "out" ];

  postPatch = ''
    substituteInPlace ./src/scripts/Makefile \
      --replace "etc" "$out/etc"
    substituteInPlace ./src/scripts/wihotspot \
      --replace "/usr" "$out"
    substituteInPlace ./src/desktop/wifihotspot.desktop \
      --replace "/usr" "$out"
    substituteInPlace ./src/scripts/policies/polkit.policy \
      --replace "/usr" "$out"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/create_ap \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          dnsmasq
          flock
          gawk
          getopt
          gnugrep
          gnused
          hostapd
          iproute2
          iptables
          iw
          kmod
          networkmanager
          procps
          which
        ]
      }

    wrapProgram $out/bin/wihotspot-gui \
      --prefix PATH : ${lib.makeBinPath [ iw ]} \
      --prefix PATH : "${placeholder "out"}/bin"

    wrapProgram $out/bin/wihotspot \
      --prefix PATH : ${lib.makeBinPath [ iw ]} \
      --prefix PATH : "${placeholder "out"}/bin"
  '';

  meta = with lib; {
    description = "Feature-rich wifi hotspot creator for Linux which provides both GUI and command-line interface";
    homepage = "https://github.com/lakinduakash/linux-wifi-hotspot";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      johnrtitor
      onny
    ];
    platforms = platforms.unix;
  };

})
