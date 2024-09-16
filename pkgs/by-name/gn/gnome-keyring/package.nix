{ lib
, stdenv
, fetchurl
, pkg-config
, dbus
, libgcrypt
, pam
, python3
, glib
, libxslt
, gettext
, gcr
, libcap_ng
, libselinux
, p11-kit
, openssh
, wrapGAppsHook3
, docbook-xsl-nons
, docbook_xml_dtd_43
, gnome
, useWrappedDaemon ? true
}:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "46.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.major version}/gnome-keyring-${version}.tar.xz";
    hash = "sha256-vybJZriot/MoXsyLs+RnucIPlTW5TcRRycVZ3c/2GSU=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    libgcrypt
    pam
    openssh
    libcap_ng
    libselinux
    gcr
    p11-kit
  ];

  nativeCheckInputs = [ dbus python3 ];

  configureFlags = [
    "--with-pkcs11-config=${placeholder "out"}/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=${placeholder "out"}/lib/pkcs11/"
    # gnome-keyring doesn't build with ssh-agent by default anymore, we need to
    # switch to using gcr https://github.com/NixOS/nixpkgs/issues/140824
    "--enable-ssh-agent"
    # cross compilation requires these paths to be explicitly declared:
    "LIBGCRYPT_CONFIG=${lib.getExe' (lib.getDev libgcrypt) "libgcrypt-config"}"
    "SSH_ADD=${lib.getExe' openssh "ssh-add"}"
    "SSH_AGENT=${lib.getExe' openssh "ssh-agent"}"
  ];

  # Tends to fail non-deterministically.
  # - https://github.com/NixOS/nixpkgs/issues/55293
  # - https://github.com/NixOS/nixpkgs/issues/51121
  doCheck = false;

  postPatch = ''
    patchShebangs build
  '';

  checkPhase = ''
    export HOME=$(mktemp -d)
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      make check
  '';

  # Use wrapped gnome-keyring-daemon with cap_ipc_lock=ep
  postFixup = lib.optionalString useWrappedDaemon ''
    files=($out/etc/xdg/autostart/* $out/share/dbus-1/services/*)

    for file in ''${files[*]}; do
      substituteInPlace $file \
        --replace "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-keyring";
    };
  };

  meta = with lib; {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keyring";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
