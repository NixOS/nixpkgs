{
  bash,
  fetchFromGitHub,
  gawk,
  git,
  lib,
  procps,
  stdenvNoCC,
  unixtools,
  unstableGitUpdater,
  unzip,
  usbutils,
  util-linux,
  wget,
  writeShellApplication,
  xdotool,
  xorg,
  yad,
}:

stdenvNoCC.mkDerivation {
  pname = "steamtinkerlaunch";
  version = "12.12-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "sonic2kk";
    repo = "steamtinkerlaunch";
    rev = "8550ab26a712b7f5f6d0947070181446b9de61fd";
    hash = "sha256-mCcxdm8odHvTt4aP58RHY6NkaUMmMbQesUtY6dvIvOc=";
  };

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  installFlags = [ "PREFIX=\${out}" ];

  nativeBuildInputs =
    let
      # We need a `steam` command in order to install the compat tool
      fakeSteam = writeShellApplication {
        name = "steam";
        text = "exit 0";
      };
    in
    [
      fakeSteam
    ];

  postInstall =
    let
      # We (ab)use writeShellApplication to produce a header for a shell script
      # here in order to add the runtimePath to the original script. We cannot
      # wrap here as that always corrupts $0 in bash scripts which STL uses to
      # install its compat tool.
      header = writeShellApplication {
        runtimeInputs = [
          bash
          gawk
          git
          procps
          unixtools.xxd
          unzip
          usbutils
          util-linux
          wget
          xdotool
          xorg.xprop
          xorg.xrandr
          xorg.xwininfo
          yad
        ];
        name = "stl-head";
        text = "";
        bashOptions = [ ];
      };
      fakeYad = writeShellApplication {
        name = "yad";
        text = "echo ${yad.version} FAKE";
      };
    in
    ''
      cp $out/bin/steamtinkerlaunch $TMPDIR/steamtinkerlaunch
      install ${lib.getExe header} -T $out/bin/steamtinkerlaunch
      tail -n +2 $TMPDIR/steamtinkerlaunch >> $out/bin/steamtinkerlaunch

      # Create a fake steam dir, it checks this and reads a few values
      steamdir=$TMPDIR/.local/share/Steam/
      mkdir -p $steamdir/config/
      echo \"path\" \"$steamdir\" > $steamdir/config/config.vdf
      mkdir $TMPDIR/.steam/
      ln -s $steamdir $TMPDIR/.steam/steam

      cp -a $out/bin/steamtinkerlaunch $TMPDIR/steamtinkerlaunch
      # yad cannot print its version without a graphical session https://github.com/v1cont/yad/issues/277
      substituteInPlace $TMPDIR/steamtinkerlaunch --replace-fail ${yad} ${fakeYad}
      HOME=$TMPDIR $TMPDIR/steamtinkerlaunch compat add

      cp -a $steamdir/compatibilitytools.d/SteamTinkerLaunch $steamcompattool
      # It creates this symlink but it points to $TMPDIR
      ln -sfn $out/bin/steamtinkerlaunch $steamcompattool/
    '';

  meta = with lib; {
    description = "Linux wrapper tool for use with the Steam client for custom launch options and 3rd party programs";
    mainProgram = "steamtinkerlaunch";
    homepage = "https://github.com/sonic2kk/steamtinkerlaunch";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      urandom
      surfaceflinger
    ];
    platforms = lib.platforms.linux;
  };
}
