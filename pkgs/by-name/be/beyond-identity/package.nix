{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  buildFHSEnv,
  glibc,
  glib,
  openssl,
  tpm2-tss,
  gtk3,
  gnome-keyring,
  polkit,
  polkit_gnome,
}:

let
  pname = "beyond-identity";
  version = "2.97.0-0";
  libPath = lib.makeLibraryPath ([
    glib
    glibc
    openssl
    tpm2-tss
    gtk3
    gnome-keyring
    polkit
    polkit_gnome
  ]);
  meta = with lib; {
    description = "Passwordless MFA identities for workforces, customers, and developers";
    homepage = "https://www.beyondidentity.com";
    downloadPage = "https://app.byndid.com/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      klden
      hornwall
    ];
    platforms = [ "x86_64-linux" ];
  };

  beyond-identity = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/${pname}_${version}/${pname}_${version}_amd64.deb";
      hash = "sha512-aOQi0hG7AZ3lIAPCDgGAjqVmNCuqFC62CjI9XPLBpvbxBgr2yi7alP952i31MufzzruzVweoQb8SWgNIHq/zIw==";
    };

    nativeBuildInputs = [
      dpkg
    ];

    unpackPhase = ''
      dpkg -x $src .
    '';

    installPhase = ''
      mkdir -p $out/opt/beyond-identity

      rm -rf usr/share/doc

      cp -ar usr/{bin,share} $out
      cp -ar opt/beyond-identity/bin $out/opt/beyond-identity

      ln -s $out/opt/beyond-identity/bin/* $out/bin/
    '';

    postFixup = ''
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.BeyondIdentity.desktop \
        --replace /usr/bin/ $out/bin/
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.webserver.BeyondIdentity.desktop \
        --replace /opt/ $out/opt/
      substituteInPlace \
        $out/opt/beyond-identity/bin/byndid-web \
        --replace /opt/ $out/opt/
      substituteInPlace \
        $out/bin/beyond-identity \
        --replace /opt/ $out/opt/ \
        --replace /usr/bin/gtk-launch ${gtk3}/bin/gtk-launch

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        --force-rpath \
        $out/bin/byndid
    '';
  };
in
# /usr/bin/pkcheck is hardcoded in binary - we need FHS
buildFHSEnv {
  inherit pname version meta;

  targetPkgs = pkgs: [
    beyond-identity
    glib
    glibc
    openssl
    tpm2-tss
    gtk3
    gnome-keyring
    polkit
    polkit_gnome
  ];

  extraInstallCommands = ''
    ln -s ${beyond-identity}/share $out
  '';

  runScript = "beyond-identity";
}
