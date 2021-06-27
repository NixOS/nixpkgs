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
, numactl
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
        numactl
        stdenv.cc.cc.lib
        zlib
      ]; in
    ''
      patchPrefix() {
        prefix="$1"
        shift
        for exe in "$@"; do
          patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath "$prefix:${libPath}" "$prefix/$exe"
        done

        while IFS= read -r -d $'\0' elf; do
          patchelf --set-rpath "$prefix:${libPath}" "$elf"
        done < <(find $prefix -name '*.so' -maxdepth 1 -print0)
      }

      patchPrefix $out/awsvpnclient "AWS VPN Client" createdump
      patchPrefix $out/awsvpnclient/Service ACVC.GTK.Service createdump

      for prog in $out/awsvpnclient/"AWS VPN Client" $out/awsvpnclient/Service/ACVC.GTK.Service; do
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
