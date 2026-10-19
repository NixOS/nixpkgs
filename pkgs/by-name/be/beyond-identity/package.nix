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
  version = "2.108.0-3";
  meta = {
    description = "Passwordless MFA identities for workforces, customers, and developers";
    homepage = "https://www.beyondidentity.com";
    downloadPage = "https://app.byndid.com/downloads";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      klden
      hornwall
    ];
    platforms = [ "x86_64-linux" ];
  };

  beyond-identity = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/${pname}_${version}/${pname}_${version}_amd64.deb";
      hash = "sha512-ehpxjuf+vAoghTcSbtasI5IMi2/lQ26DUrpxQEJL/9XfPY95JYQZ/LJkOo4/pW+LR9n6fX6zgeNm60j29PzKtA==";
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
      cp -ar opt/beyond-identity/{bin,etc} $out/opt/beyond-identity

      ln -s $out/opt/beyond-identity/bin/* $out/bin/
    '';

    postFixup = ''
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.BeyondIdentity.desktop \
        --replace-fail /usr/bin/ $out/bin/
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.webserver.BeyondIdentity.desktop \
        --replace-fail /opt/ $out/opt/
      substituteInPlace \
        $out/opt/beyond-identity/bin/byndid-web \
        --replace-fail /opt/ $out/opt/
      substituteInPlace \
        $out/bin/beyond-identity \
        --replace-fail /opt/ $out/opt/ \
        --replace-fail /usr/bin/gtk-launch ${gtk3}/bin/gtk-launch
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
