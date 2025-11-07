{
  mkDerivation,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  xdg-utils,
  dbus,
  getconf,
  glibc,
  libXrandr,
  libX11,
  libXext,
  libXdamage,
  libXtst,
  libSM,
  libXfixes,
  coreutils,
  wrapQtAppsHook,
  icu63,
  nss,
  minizip,
}:

mkDerivation rec {
  pname = "teamviewer";
  # teamviewer itself has not development files but the dev output removes propagated other dev outputs from runtime
  outputs = [
    "out"
    "dev"
  ];
  version = "15.71.4";

  src =
    let
      base_url = "https://dl.teamviewer.com/download/linux/version_${lib.versions.major version}x";
    in
    {
      x86_64-linux = fetchurl {
        url = "${base_url}/teamviewer_${version}_amd64.deb";
        hash = "sha256-DztZRVBIFdLkZX1a89tVwJvJicgsm5YTux0ezyWL1+w=";
      };
      aarch64-linux = fetchurl {
        url = "${base_url}/teamviewer_${version}_arm64.deb";
        hash = "sha256-lKEAuMsScbnEkgR6VFykEyar55u/Fdt5VcCWnKPwJLU=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapQtAppsHook
  ];
  buildInputs = [
    minizip
    icu63
    nss
  ];

  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin $out/share/applications
    cp -a opt/teamviewer/* $out/share/teamviewer
    rm -R \
      $out/share/teamviewer/logfiles \
      $out/share/teamviewer/config \
      $out/share/teamviewer/tv_bin/script/{teamviewer_setup,teamviewerd.sysv,teamviewerd.service,teamviewerd.*.conf,tv-delayed-start.sh}

    # Teamviewer packages its own qt library files. So do not use nixpkgs qt files. These will cause issues
    # See https://github.com/NixOS/nixpkgs/issues/321333

    ln -s $out/share/teamviewer/tv_bin/script/teamviewer $out/bin
    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin
    ln -s $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop $out/share/applications
    ln -s /var/lib/teamviewer $out/share/teamviewer/config
    ln -s /var/log/teamviewer $out/share/teamviewer/logfiles
    ln -s ${xdg-utils}/bin $out/share/teamviewer/tv_bin/xdg-utils

    declare in_script_dir="./opt/teamviewer/tv_bin/script"

    install -d "$out/share/dbus-1/services"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.service" "$out/share/dbus-1/services"
    substituteInPlace "$out/share/dbus-1/services/com.teamviewer.TeamViewer.service" \
      --replace-fail '/opt/teamviewer/tv_bin/TeamViewer' \
        "$out/share/teamviewer/tv_bin/TeamViewer"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.Desktop.service" "$out/share/dbus-1/services"
    substituteInPlace "$out/share/dbus-1/services/com.teamviewer.TeamViewer.Desktop.service" \
      --replace-fail '/opt/teamviewer/tv_bin/TeamViewer_Desktop' \
        "$out/share/teamviewer/tv_bin/TeamViewer_Desktop"

    install -d "$out/share/dbus-1/system.d"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.Daemon.conf" "$out/share/dbus-1/system.d"

    install -d "$out/share/polkit-1/actions"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.policy" "$out/share/polkit-1/actions"
    substituteInPlace "$out/share/polkit-1/actions/com.teamviewer.TeamViewer.policy" \
      --replace '/opt/teamviewer/tv_bin/script/execscript' \
        "$out/share/teamviewer/tv_bin/script/execscript"

    for i in 16 20 24 32 48 256; do
      size=$i"x"$i

      mkdir -p $out/share/icons/hicolor/$size/apps
      ln -s $out/share/teamviewer/tv_bin/desktop/teamviewer_$i.png $out/share/icons/hicolor/$size/apps/TeamViewer.png
    done;

    sed -i "s,/opt/teamviewer,$out/share/teamviewer,g" $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop

    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_aux \
      --replace '/lib64/ld-linux-x86-64.so.2' '${glibc.out}/lib/ld-linux-x86-64.so.2'
    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_config \
      --replace '/var/run/' '/run/'
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        getconf
        coreutils
      ]
    }"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libXrandr
        libX11
        libXext
        libXdamage
        libXtst
        libSM
        libXfixes
        dbus
        icu63
      ]
    }"
  ];

  postFixup = ''
    wrapProgram $out/share/teamviewer/tv_bin/teamviewerd ''${makeWrapperArgs[@]}
    # tv_bin/script/teamviewer runs tvw_main which runs tv_bin/TeamViewer
    wrapProgram $out/share/teamviewer/tv_bin/script/teamviewer ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
    wrapProgram $out/share/teamviewer/tv_bin/teamviewer-config ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
    wrapProgram $out/share/teamviewer/tv_bin/TeamViewer_Desktop ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
  '';

  dontStrip = true;
  dontWrapQtApps = true;
  preferLocalBuild = true;

  passthru.updateScript = ./update-teamviewer.sh;

  meta = with lib; {
    homepage = "https://www.teamviewer.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      jagajaga
      jraygauthier
      gador
      c4patino
    ];
  };
}
