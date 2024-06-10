{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, gtk3
, dpkg
, curl
, lttng-ust
, wrapGAppsHook
, libredirect
}:

stdenv.mkDerivation rec {
  pname = "aws-client-vpn";
  version = "1.0.3";

  src = fetchurl {
    url = "https://d20adtppz83p9s.cloudfront.net/GTK/${version}/awsvpnclient_amd64.deb";
    sha256 = "sha256-kqeV1DlOW1UWd+l0C5qQN4G/wUr5JAAqIa5vXCfzIqM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    curl
    lttng-ust
    gtk3
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv opt/awsvpnclient/* $out/bin

    for app in "$out/bin/AWS VPN Client" "$out/bin/Service/ACVC.GTK.Service"; do
      wrapProgram "$app" \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /opt/awsvpnclient=$out/bin \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
        "''${gappsWrapperArgs[@]}"
    done
  '';

  preFixup = ''
    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/bin/libcoreclrtraceptprovider.so
    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/bin/Service/libcoreclrtraceptprovider.so
  '';

  postInstall = ''
    install --mode=444 -D etc/systemd/system/awsvpnclient.service $out/etc/systemd/system/awsvpnclient.service
  '';

  dontWrapGApps = true;

  # Without this, crashes at startup with:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-what-is.html";
    description = "AWS Client VPN";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcwitt ];
  };
}
