{ lib
, stdenv
, fetchurl
, autoreconfHook
, gettext
, pkg-config
, writeShellScript
, openldap
, libkrb5
, dbus
, nspr
, nss
, openssl
, libidn2
, libuuid
, talloc
, tevent
, curl
, libxml2
, xmlrpc_c
, jansson
, popt
, runtimeDir ? "/run/certmonger"
, storeDir ? "/var/lib/certmonger"
}:
let
  # patch runtime /libexec + storeDir (it is hardcoded in binary for runtime)
  # needed for non-NixOS systems
  # For example "certmonger" will create file in "/var/lib/certmonger/cas/20240222033838" with hardcoded path:
  # ca_external_helper=/nix/store/h3xp6zjjvq5gy2wcllfv5l578fbjr9il-certmonger-0.79.15/libexec/certmonger/certmaster-submit
  certmongerWrapper = writeShellScript "certmongerWrapper" ''
    # create runtime impure binaries
    if [ ! -d "${runtimeDir}" ]; then
      mkdir -m 0750 -p "${runtimeDir}"
    fi
    if [ "$(readlink "${runtimeDir}/libexec")" != "@out@/libexec" ]; then
      rm -f "${runtimeDir}/libexec"
      ln -s "@out@/libexec" "${runtimeDir}/libexec"
    fi

    # create required directories
    if [ ! -d "${storeDir}/cas" ]; then
      mkdir -m 0700 -p "${storeDir}/cas"
    fi
    if [ ! -d "${storeDir}/local" ]; then
      mkdir -m 0700 -p "${storeDir}/local"
    fi
    if [ ! -d "${storeDir}/requests" ]; then
      mkdir -m 0700 -p "${storeDir}/requests"
    fi

    # run original binary
    fileName="''${0##*/}"
    exec "@out@/.bin-unwrapped/$fileName" "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "certmonger";
  version = "0.79.19";

  src = fetchurl {
    url = "https://pagure.io/certmonger/archive/${finalAttrs.version}/certmonger-${finalAttrs.version}.tar.gz";
    hash = "sha256-MoyPHbbsN0B8Dd9qyz64y9CCkSBpgbFe82hImJwf+LE=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    openldap
    libkrb5
    dbus
    nspr
    nss
    openssl
    libidn2
    libuuid
    talloc
    tevent
    curl
    libxml2
    xmlrpc_c
    jansson
    popt
  ];

  postPatch = ''
    # patch required if '--enable-systemd' is enabled
    substituteInPlace configure.ac \
      --replace '`pkg-config --variable=systemdsystemunitdir systemd 2> /dev/null`' '"${placeholder "out"}/lib/systemd/system"'

    # patch runtime /libexec
    substituteInPlace configure.ac \
      --replace 'mylibexecdir="$libexecdir/''${PACKAGE_NAME}"' 'mylibexecdir="${runtimeDir}/libexec/certmonger"'

    # skip installing /var/lib/certmonger
    substituteInPlace src/Makefile.am \
      --replace '	mkdir -m 700 -p $(DESTDIR)@CM_STORE' '# mkdir -m 700 -p $(DESTDIR)@CM_STORE'
  '';

  configureFlags = [
    "--with-system-bus-services-dir=${placeholder "out"}/etc/dbus-1/system.d"
    "--with-session-bus-services-dir=${placeholder "out"}/etc/dbus-1/session.d"
    "--with-homedir=${runtimeDir}"
    "--with-tmpdir=${runtimeDir}"
    "--with-file-store-dir=${storeDir}"
    "--with-xmlrpc"
    (lib.enableFeature true "systemd")
    (lib.enableFeature true "tmpfiles")
    (lib.enableFeature false "dsa")
    (lib.enableFeature true "pie")
    (lib.enableFeature true "now")
  ];

  postFixup = ''
    mkdir -p $out/.bin-unwrapped
    for file in $out/bin/*; do
      fileName=$(basename $file)
      mv "$out/bin/$fileName" "$out/.bin-unwrapped/$fileName"
      ln -s "$out/.bin-unwrapped/.wrapper" "$out/bin/$fileName"
    done;

    substitute ${certmongerWrapper} $out/.bin-unwrapped/.wrapper \
      --subst-var out
    chmod +x $out/.bin-unwrapped/.wrapper
  '';

  meta = with lib; {
    description = "Certificate status monitor and PKI enrollment client";
    longDescription = ''
      Certmonger is a service which is primarily concerned with getting your
      system enrolled with a certificate authority (CA) and keeping it enrolled.
    '';
    homepage = "https://pagure.io/certmonger/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.patryk4815 ];
    platforms = platforms.linux;
    mainProgram = "certmonger";
  };
})
