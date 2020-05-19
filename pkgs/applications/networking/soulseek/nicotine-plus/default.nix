{ lib
, stdenv
, fetchFromGitHub
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, libnotify
, geoip

# Test dependencies
, xvfb_run
, gnome3
}:

python3.pkgs.buildPythonApplication {
  pname = "nicotine-plus";
  version = "unstable-2020-05-24";

  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = "0f9e4e1c2391196d4070df5851ff48601aceaf7f";
    hash = "sha256-kSDqoxmX9beqL98tMQylbhCZVMmQy6/oVOyW1xnxFLY=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  # Avoid double-wrapping; see preFixup
  # and https://nixos.org/nixpkgs/manual/#ssec-gnome-common-issues.
  dontWrapGApps = true;

  buildInputs = [
    gobject-introspection
    gtk3
    libnotify
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    miniupnpc
    mutagen
    (GeoIP.override { inherit geoip; })
  ];

  checkInputs = [ python3.pkgs.pytest ] ++ lib.optionals (!stdenv.isDarwin) [
    # The gtk3 package doesn't enable X11 on Darwin, so we can't
    # use xvfb-run.
    xvfb_run
    python3.pkgs.robotframework
    # Avoid warnings about missing icons.
    gnome3.defaultIconTheme
  ];

  # Run setup hooks for installCheckPhase;
  # see https://github.com/NixOS/nixpkgs/issues/56943.
  strictDeps = false;

  postPatch = ''
    # Remove non-free files.
    sh debian/nicotine-rm-nonfree

    # Find installed files in the appropriate place.
    # TODO: Move to importlib_resources upstream so this can be removed.
    find pynicotine -name '*.py' \
      -exec sed -i "s|sys\.prefix|'$out'|g" {} +
  '';

  preBuild = ''
    # Regenerate languages/*/LC_MESSAGES/nicotine.mo files from source.
    (cd languages; python msgfmtall.py)
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/nicotine.desktop \
      --replace "Exec=nicotine" "Exec=$out/bin/nicotine"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    export PATH="$out/bin:$PATH"
    export HOME="$(mktemp -d)"

    # These tests should be kept in sync with debian/tests/control to
    # the extent possible.

    nicotine --version | grep -q 'Nicotine+'

    pytest test/unit

  '' + lib.optionalString (!stdenv.isDarwin) ''
    xvfb-run -s '-screen 0 1024x768x24' \
      robot test/integration/nicotine.robot

  '' + ''
    runHook postInstallCheck
  '';

  meta = {
    description = "A graphical client for the SoulSeek peer-to-peer system";
    homepage = "https://www.nicotine-plus.org";
    license = [
      # Main license
      lib.licenses.gpl3Plus
      # Per sounds/default/license.txt
      lib.licenses.cc0
    ];
    maintainers = with lib.maintainers; [ klntsky emily ];
    platforms = lib.platforms.unix;
  };
}
