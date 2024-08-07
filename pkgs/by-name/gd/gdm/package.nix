{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  substituteAll,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  itstool,
  xorg,
  accountsservice,
  libX11,
  gnome,
  systemd,
  dconf,
  gtk3,
  libcanberra-gtk3,
  pam,
  libgudev,
  libselinux,
  keyutils,
  audit,
  gobject-introspection,
  plymouth,
  coreutils,
  xorgserver,
  xwayland,
  dbus,
  nixos-icons,
  runCommand,
}:

let

  override = substituteAll {
    src = ./org.gnome.login-screen.gschema.override;
    icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
  };

in

stdenv.mkDerivation (finalAttrs: {
  pname = "gdm";
  version = "47.alpha";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${lib.versions.major finalAttrs.version}/gdm-${finalAttrs.version}.tar.xz";
    hash = "sha256-A1lcGdkSyPUOWYsDcGCXzBPLhT90NbfReJKMPvYOMag=";
  };

  mesonFlags = [
    "-Dgdm-xsession=true"
    # TODO: Setup a default-path? https://gitlab.gnome.org/GNOME/gdm/-/blob/6fc40ac6aa37c8ad87c32f0b1a5d813d34bf7770/meson_options.txt#L6
    "-Dinitial-vt=${finalAttrs.passthru.initialVT}"
    "-Dudev-dir=${placeholder "out"}/lib/udev/rules.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  nativeBuildInputs = [
    dconf
    glib # for glib-compile-schemas
    itstool
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    json-glib
    gtk3
    keyutils
    libX11
    libcanberra-gtk3
    libgudev
    libselinux
    pam
    plymouth
    systemd
    xorg.libXdmcp
  ];

  patches = [
    # GDM fails to find g-s with the following error in the journal.
    # gdm-x-session[976]: dbus-run-session: failed to exec 'gnome-session': No such file or directory
    # https://gitlab.gnome.org/GNOME/gdm/-/merge_requests/92
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gdm/-/commit/ccecd9c975d04da80db4cd547b67a1a94fa83292.patch";
      hash = "sha256-5hKS9wjjhuSAYwXct5vS0dPbmPRIINJoLC0Zm1naz6Q=";
      revert = true;
    })

    # Change hardcoded paths to nix store paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit
        coreutils
        plymouth
        xorgserver
        xwayland
        dbus
        ;
    })

    # The following patches implement certain environment variables in GDM which are set by
    # the gdm configuration module (nixos/modules/services/x11/display-managers/gdm.nix).

    ./gdm-x-session_extra_args.patch

    # Allow specifying a wrapper for running the session command.
    ./gdm-x-session_session-wrapper.patch

    # Forwards certain environment variables to the gdm-x-session child process
    # to ensure that the above two patches actually work.
    ./gdm-session-worker_forward-vars.patch

    # Set up the environment properly when launching sessions
    # https://github.com/NixOS/nixpkgs/issues/48255
    ./reset-environment.patch
  ];

  postPatch = ''
    # Upstream checks some common paths to find an `X` binary. We already know it.
    echo #!/bin/sh > build-aux/find-x-server.sh
    echo "echo ${lib.getBin xorg.xorgserver}/bin/X" >> build-aux/find-x-server.sh
    patchShebangs build-aux/find-x-server.sh

    # Reverts https://gitlab.gnome.org/GNOME/gdm/-/commit/b0f802e36ff948a415bfd2bccaa268b6990515b7
    # The gdm-auth-config tool is probably not too useful for NixOS, but we still want the dconf profile
    # installed (mostly just because .passthru.tests can make use of it).
    substituteInPlace meson.build \
      --replace-fail "dconf_prefix = dconf_dep.get_variable(pkgconfig: 'prefix')" "dconf_prefix = gdm_prefix"
  '';

  preInstall = ''
    install -D ${override} "$DESTDIR/$out/share/glib-2.0/schemas/org.gnome.login-screen.gschema.override"
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    for o in $(getAllOutputNames); do
        # debug is created later by _separateDebugInfo hook.
        if [[ "$o" = "debug" ]]; then continue; fi
        mv "$DESTDIR''${!o}" "$(dirname "''${!o}")"
    done

    mv "$DESTDIR/etc" "$out"

    # Ensure we did not forget to install anything.
    rmdir --parents --ignore-fail-on-non-empty "$DESTDIR${builtins.storeDir}"
    [ ! -e "$DESTDIR" ] || (echo "Some files are still left in a temporary DESTDIR and aren't properly installed."; exit 1)

    # We are setting DESTDIR so the post-install script does not compile the schemas.
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  env = {
    # HACK: We want to install configuration files to $out/etc
    # but GDM should read them from /etc on a NixOS system.
    # With autotools, it was possible to override Make variables
    # at install time but Meson does not support this
    # so we need to convince it to install all files to a temporary
    # location using DESTDIR and then move it to proper one in postInstall.
    DESTDIR = "dest";
  };

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript { packageName = "gdm"; };

    # Used in GDM NixOS module
    # Don't remove.
    initialVT = "7";
    dconfDb = "${finalAttrs.finalPackage}/share/gdm/greeter-dconf-defaults";
    dconfProfile = "user-db:user\nfile-db:${finalAttrs.passthru.dconfDb}";

    tests = {
      profile = runCommand "gdm-profile-test" { } ''
        if test "${finalAttrs.passthru.dconfProfile}" != "$(cat ${finalAttrs.finalPackage}/share/dconf/profile/gdm)"; then
          echo "GDM dconf profile changed, please update gdm.nix"
          exit 1
        fi
        touch $out
      '';
    };
  };

  meta = with lib; {
    description = "Program that manages graphical display servers and handles graphical user logins";
    homepage = "https://gitlab.gnome.org/GNOME/gdm";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
