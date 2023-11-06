{ lib
, telegram-desktop-unwrapped
, wrapGAppsHook
, wrapQtAppsHook
, xdg-utils
, xorg
, symlinkJoin
, xcursorHack ? true
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
    wrapperArgs=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
      ${lib.optionalString xcursorHack ''
        # Hack to load libXcursor on some setups
        # https://github.com/NixOS/nixpkgs/issues/181176
        --prefix LD_LIBRARY_PATH : "${xorg.libXcursor}/lib"
      ''}
    )
    wrapProgram $out/bin/telegram-desktop "''${wrapperArgs[@]}"
  '';

  passthru = {
    inherit (telegram) tg_owt;
  };

  inherit (telegram) meta;
}
