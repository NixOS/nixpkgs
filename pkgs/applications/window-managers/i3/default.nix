{
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  makeWrapper,
  meson,
  ninja,
  installShellFiles,
  libxcb,
  xcbutilkeysyms,
  xcbutil,
  xcbutilwm,
  xcbutilxrm,
  libstartup_notification,
  libX11,
  pcre2,
  libev,
  yajl,
  xcb-util-cursor,
  perl,
  pango,
  perlPackages,
  libxkbcommon,
  xorgserver,
  xvfb-run,
  xdotool,
  xorg,
  which,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  findXMLCatalogs,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i3";
  version = "4.24";

  src = fetchFromGitHub {
    owner = "i3";
    repo = "i3";
    tag = finalAttrs.version;
    hash = "sha256-2tuhfB/SMN+osCBfZtw/yDPhNNEhBH4Qo6dexpqVWYk=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
    installShellFiles
    perl
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
  ];

  mesonFlags = [
    (lib.mesonBool "docs" true)
    (lib.mesonBool "mans" true)
  ];

  buildInputs = [
    libxcb
    xcbutilkeysyms
    xcbutil
    xcbutilwm
    xcbutilxrm
    libxkbcommon
    libstartup_notification
    libX11
    pcre2
    libev
    yajl
    xcb-util-cursor
    perl
    pango
    perlPackages.AnyEventI3
    perlPackages.X11XCB
    perlPackages.IPCRun
    perlPackages.ExtUtilsPkgConfig
    perlPackages.InlineC
  ];

  postPatch = ''
    patchShebangs .

    # This testcase generates a Perl executable file with a shebang, and
    # patchShebangs can't replace a shebang in the middle of a file.
    if [ -f testcases/t/318-i3-dmenu-desktop.t ]; then
      substituteInPlace testcases/t/318-i3-dmenu-desktop.t \
        --replace-fail "#!/usr/bin/env perl" "#!${lib.getExe perl}"
    fi
  '';

  # xvfb-run is available only on Linux
  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = lib.optionals finalAttrs.finalPackage.doCheck [
    xorgserver
    xvfb-run
    xdotool
    xorg.setxkbmap
    xorg.xrandr
    which
  ];

  checkPhase = ''
    runHook preCheck

    test_failed=
    # "| cat" disables fancy progress reporting which makes the log unreadable.
    ./complete-run.pl -p 1 --keep-xserver-output | cat || test_failed="complete-run.pl returned $?"
    if [ -z "$test_failed" ]; then
      # Apparently some old versions of `complete-run.pl` did not return a
      # proper exit code, so check the log for signs of errors too.
      grep -q '^not ok' latest/complete-run.log && test_failed="test log contains errors" ||:
    fi
    if [ -n "$test_failed" ]; then
      echo "***** Error: $test_failed"
      echo "===== Test log ====="
      cat latest/complete-run.log
      echo "===== End of test log ====="
      false
    fi

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done

    installManPage man/*.1
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) i3wm;
    };
  };

  meta = {
    description = "Tiling window manager";
    homepage = "https://i3wm.org";
    maintainers = with lib.maintainers; [
      modulistic
      fpletz
    ];
    mainProgram = "i3";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;

    longDescription = ''
      A tiling window manager primarily targeted at advanced users and
      developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as
      floating windows. Configured via plain text file. Multi-monitor.
      UTF-8 clean.
    '';
  };
})
