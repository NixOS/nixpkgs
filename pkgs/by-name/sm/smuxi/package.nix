{
  stdenv,
  autoconf,
  automake,
  itstool,
  intltool,
  pkg-config,
  fetchFromGitHub,
  glib,
  gettext,
  sqlite,
  mono,
  stfl,
  makeWrapper,
  lib,
  guiSupport ? true,
  gtk-sharp-2_0,
  gdk-pixbuf,
  pango,
}:

stdenv.mkDerivation rec {
  pname = "smuxi";
  version = "unstable-2023-07-01";

  runtimeLoaderEnvVariableName =
    if stdenv.hostPlatform.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";

  src = fetchFromGitHub {
    owner = "meebey";
    repo = "smuxi";
    rev = "3e4b5050b66944532e95df3c31245c8ae6379b3f";
    hash = "sha256-zSsckcEPEX99v3RkM4O4+Get5tnz4FOpiodoTGTZq+8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    autoconf
    automake
    itstool
    intltool
    gettext
    mono
    stfl
  ]
  ++ lib.optionals (guiSupport) [
    gtk-sharp-2_0
    # loaded at runtime by GTK#
    gdk-pixbuf
    pango
  ];

  preConfigure = ''
    NOCONFIGURE=1 NOGIT=1 ./autogen.sh
  '';

  configureFlags = [
    "--disable-frontend-gnome"
    "--enable-frontend-stfl"
  ]
  ++ lib.optional guiSupport "--enable-frontend-gnome";

  postInstall = ''
    makeWrapper "${mono}/bin/mono" "$out/bin/smuxi-message-buffer" \
      --add-flags "$out/lib/smuxi/smuxi-message-buffer.exe" \
      --prefix ${runtimeLoaderEnvVariableName} : ${
        lib.makeLibraryPath [
          gettext
          sqlite
        ]
      }

    makeWrapper "${mono}/bin/mono" "$out/bin/smuxi-server" \
      --add-flags "$out/lib/smuxi/smuxi-server.exe" \
      --prefix ${runtimeLoaderEnvVariableName} : ${
        lib.makeLibraryPath [
          gettext
          sqlite
        ]
      }

    makeWrapper "${mono}/bin/mono" "$out/bin/smuxi-frontend-stfl" \
      --add-flags "$out/lib/smuxi/smuxi-frontend-stfl.exe" \
      --prefix ${runtimeLoaderEnvVariableName} : ${
        lib.makeLibraryPath [
          gettext
          sqlite
          stfl
        ]
      }

    makeWrapper "${mono}/bin/mono" "$out/bin/smuxi-frontend-gnome" \
      --add-flags "$out/lib/smuxi/smuxi-frontend-gnome.exe" \
      --prefix MONO_GAC_PREFIX : ${if guiSupport then gtk-sharp-2_0 else ""} \
      --prefix ${runtimeLoaderEnvVariableName} : ${
        lib.makeLibraryPath [
          gettext
          glib
          sqlite
          gtk-sharp-2_0
          gtk-sharp-2_0.gtk
          gdk-pixbuf
          pango
        ]
      }

    # install log4net and nini libraries
    mkdir -p $out/lib/smuxi/
    cp -a lib/log4net.dll $out/lib/smuxi/
    cp -a lib/Nini.dll $out/lib/smuxi/

    # install GTK+ icon theme on Darwin
    ${
      if guiSupport && stdenv.hostPlatform.isDarwin then
        "
      mkdir -p $out/lib/smuxi/icons/
      cp -a images/Smuxi-Symbolic $out/lib/smuxi/icons/
    "
      else
        ""
    }
  '';

  meta = {
    homepage = "https://smuxi.im/";
    downloadPage = "https://smuxi.im/download/";
    changelog = "https://github.com/meebey/smuxi/releases/tag/v${version}";
    description = "irssi-inspired, detachable, cross-platform, multi-protocol (IRC, XMPP/Jabber) chat client for the GNOME desktop";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      meebey
    ];
  };
}
