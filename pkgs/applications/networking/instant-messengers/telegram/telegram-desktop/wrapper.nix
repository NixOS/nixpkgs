{ lib
, telegram-desktop-unwrapped
, wrapGAppsHook
, wrapQtAppsHook
, xdg-utils
, xorg
, symlinkJoin
}:

let
  telegram = telegram-desktop-unwrapped;
in symlinkJoin {
  name = "telegram-desktop-${telegram.version}";

  paths = [ telegram ];

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    wrapGAppsHook
    wrapQtAppsHook
  ];

  inherit (telegram) buildInputs;

  postBuild = ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/telegram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${xorg.libXcursor}/lib" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  passthru = {
    inherit (telegram) tg_owt;
  };

  inherit (telegram) meta;
}
