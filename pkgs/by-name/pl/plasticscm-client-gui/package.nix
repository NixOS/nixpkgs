{
  buildFHSEnv,
  extraLibs ? _: [ ],
  extraPkgs ? _: [ ],
  imagemagick,
  lib,
  makeWrapper,
  plasticscm-client-core-unwrapped,
  plasticscm-client-gui-unwrapped,
  plasticscm-theme,
}:
assert plasticscm-client-gui-unwrapped.version == plasticscm-client-core-unwrapped.version;
assert plasticscm-client-gui-unwrapped.version == plasticscm-theme.version;
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

      # Undocumented dependencies discovered from testing
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
      icu74
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
    mv $out/bin/$pname $out/bin/.$pname-fhsenv

    for app in plasticgui semanticmergetool gtkmergetool gluon; do
      makeWrapper $out/bin/.$pname-fhsenv $out/bin/$app \
        --add-flags /usr/bin/$app
    done

    mkdir -p $out/share/applications
    for entry in ${plasticscm-client-gui-unwrapped}/share/applications/*; do
      substitute $entry $out/share/applications/$(basename $entry) \
        --replace-quiet /opt/plasticscm5/client/linplasticx plasticgui \
        --replace-quiet /opt/plasticscm5/client/lingluonx gluon \
        --replace-quiet /opt/plasticscm5/theme/avalonia/icons/linunityvcs.ico linunityvcs \
        --replace-quiet /opt/plasticscm5/theme/avalonia/icons/lingluonx.ico lingluonx
    done

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
