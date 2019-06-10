{
 stdenv,
 appimage-run,
 fetchurl,
 runtimeShell,
}:

stdenv.mkDerivation rec {
  github-user = "LedgerHQ";
  pname = "ledger-live-desktop";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/${github-user}/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    sha256 = "0b919ilvv3zi17fnzngnnmg28dxqlq0dvj3fdvb50kh3ibrhdcfz";
  };

  buildInputs = [ appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp $src $out/share/${pname}
    echo "#!${runtimeShell}" > $out/bin/${pname}
    echo "${appimage-run}/bin/appimage-run $out/share/${pname}" >> $out/bin/${pname}
    chmod +x $out/bin/${pname} $out/share/${pname}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = ''
    The companion to your Ledger hardware wallet
    Easily set up and manage your Ledger device
    '';
    homepage = https://www.ledger.com/live;
    license = licenses.mit;
    maintainers = with maintainers; [ thedavidmeister ];
    platforms = [ "x86_64-linux" ];
  };
}
