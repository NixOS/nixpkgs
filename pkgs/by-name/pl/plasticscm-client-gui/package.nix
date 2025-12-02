{
  buildFHSEnv,
  extraLibs ? _: [ ],
  extraPkgs ? _: [ ],
  imagemagick,
  makeWrapper,
  plasticscm-client-core-unwrapped,
  plasticscm-client-gui-unwrapped,
  plasticscm-theme,
}:
buildFHSEnv {
  pname = "plasticscm-client-gui";
  inherit (plasticscm-client-gui-unwrapped) version meta;

  runScript = "";

  targetPkgs =
    pkgs:
    with pkgs;
    [
      plasticscm-client-gui-unwrapped

      # Dependencies from the Debian package
      plasticscm-client-core-unwrapped

      fontconfig
    ]
    ++ extraPkgs pkgs;

  multiPkgs =
    pkgs:
    with pkgs;
    [
      # Dependencies from the Debian package
      glibc.out
      libgcc.lib
      krb5.lib
      lttng-ust.out
      openssl_3.out
      icu76
      plasticscm-theme

      # Transitive dependencies from the Debian package
      libidn2.out
      libunistring
      e2fsprogs.out
      keyutils.lib
      numactl.out
      libz

      # Undocumented dependencies discovered from testing
      gtk3
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
    ]
    ++ extraLibs pkgs;

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];

  extraBuildCommands = ''
    for app in linplasticx lingluonx; do
      cp --remove-destination $(readlink $out/opt/plasticscm5/client/$app) $out/opt/plasticscm5/client/$app
    done
  '';

  extraInstallCommands = ''
    mv $out/bin/plasticscm-client-gui $out/bin/.plasticscm-client-gui-fhsenv

    for app in plasticgui semanticmergetool gtkmergetool gluon; do
      makeWrapper $out/bin/.plasticscm-client-gui-fhsenv $out/bin/$app \
        --add-flags /usr/bin/$app
    done

    mkdir -p $out/share/applications

    for entry in ${plasticscm-client-gui-unwrapped}/share/applications/{unityvcs,plasticx}.desktop; do
      substitute $entry $out/share/applications/$(basename $entry) \
        --replace-fail /opt/plasticscm5/client/linplasticx plasticgui \
        --replace-fail /opt/plasticscm5/theme/avalonia/icons/linunityvcs.ico linunityvcs
    done

    substitute ${plasticscm-client-gui-unwrapped}/share/applications/gluonx.desktop \
      $out/share/applications/gluonx.desktop \
      --replace-fail /opt/plasticscm5/client/lingluonx gluon \
      --replace-fail /opt/plasticscm5/theme/avalonia/icons/lingluonx.ico lingluonx

    for ico in ${plasticscm-client-gui-unwrapped}/opt/plasticscm5/theme/avalonia/icons/*; do
      tmpdir=$(mktemp -d)
      magick $ico $tmpdir/$(basename $ico .ico).png
      for png in $tmpdir/*; do
        size=$(magick identify -format %wx%h $png)
        install -Dm444 -T $png $out/share/icons/hicolor/$size/apps/$(basename $ico .ico).png
      done
    done
  '';
}
