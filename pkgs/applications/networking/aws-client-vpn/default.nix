{ stdenv
, lib
, curl
, dpkg
, fetchurl
, gtk3
, icu
, kerberos
, libredirect
, lttng-ust
, wrapGAppsHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "aws-client-vpn";
  version = "1.0.0";

  src = fetchurl {
    url = "https://d20adtppz83p9s.cloudfront.net/GTK/${version}/awsvpnclient_amd64.deb";
    sha256 = "0nxmx83wbzgx648fcw5rqbdzi6v93qkpcnbb6qf1z6zzpg17c4br";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -av etc opt/awsvpnclient usr/share $out
    ln -s "$out/awsvpnclient/AWS VPN Client" "$out/bin/AWS VPN Client"
    ln -s "$out/awsvpnclient/Service/ACVC.GTK.Service" "$out/bin/ACVC.GTK.Service"
  '';

  dontWrapGApps = true;

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        curl
        gtk3
        icu
        kerberos
        lttng-ust
        stdenv.cc.cc.lib
        zlib
      ]; in
    ''
      for exe in "$out/awsvpnclient/AWS VPN Client" \
                 "$out/awsvpnclient/Service/ACVC.GTK.Service" \
                 "$out/awsvpnclient/createdump" \
                 "$out/awsvpnclient/Service/createdump"
      do
        patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath $out/awsvpnclient:${libPath} "$exe"
      done

      while IFS= read -r -d $'\0' file; do
        patchelf --set-rpath $out/awsvpnclient:${libPath} "$file"
      done < <(find $out/awsvpnclient -name '*.so' -print0)

      for prog in "$out/awsvpnclient/AWS VPN Client" \
                  "$out/awsvpnclient/Service/ACVC.GTK.Service"
      do
        wrapProgram "$prog" \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set NIX_REDIRECTS /opt/awsvpnclient=$out/awsvpnclient \
          "''${gappsWrapperArgs[@]}"
      done
    '';

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-what-is.html";
    description = "Managed client-based VPN service";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcwitt ];
  };
}
