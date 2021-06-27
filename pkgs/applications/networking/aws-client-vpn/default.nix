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
  name = "aws-client-vpn-${version}";
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
    mkdir -p $out
    cp -av etc opt/awsvpnclient usr/share $out
    mkdir -p $out/bin
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
      ];

      executables = [
        "AWS VPN Client"
        "Service/ACVC.GTK.Service"
        "createdump"
        "Service/createdump"
      ];

      entryPoints = [
        "AWS VPN Client"
        "Service/ACVC.GTK.Service"
      ];
    in
    ''
      for file in ${lib.concatMapStringsSep " " (s: ''"$out/awsvpnclient/${s}"'') executables}; do
        patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath $out/awsvpnclient:${libPath} "$file"
      done

      while IFS= read -r -d $'\0' file; do
        patchelf --set-rpath $out/awsvpnclient:${libPath} "$file"
      done < <(find $out/awsvpnclient -name '*.so' -print0)

      for file in ${lib.concatMapStringsSep " " (s: ''"$out/awsvpnclient/${s}"'') entryPoints}; do
        wrapProgram "$file" \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set NIX_REDIRECTS /opt/awsvpnclient=$out/awsvpnclient \
          "''${gappsWrapperArgs[@]}"
      done
    '';

  meta = with lib; {
    homepage = https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-what-is.html;
    description = "Managed client-based VPN service";
    license = lib.licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcwitt ];
  };
}
