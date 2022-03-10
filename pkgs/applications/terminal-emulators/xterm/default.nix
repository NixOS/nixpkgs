{ lib, stdenv, fetchurl, fetchpatch, xorg, ncurses, freetype, fontconfig
, pkg-config, makeWrapper, nixosTests, writeScript, common-updater-scripts, git
, nixfmt, nix, gnused, coreutils, enableDecLocator ? true }:

stdenv.mkDerivation rec {
  pname = "xterm";
  version = "371";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/xterm/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/xterm/${pname}-${version}.tgz"
    ];
    sha256 = "MviIJ3sZ4o68CjESv/AAYHwHvtBnnKoL7rs2+crUhPU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper pkg-config fontconfig ];

  buildInputs = [
    xorg.libXaw
    xorg.xorgproto
    xorg.libXt
    xorg.libXext
    xorg.libX11
    xorg.libSM
    xorg.libICE
    ncurses
    freetype
    xorg.libXft
    xorg.luit
  ];

  patches = [ ./sixel-256.support.patch ]
    ++ lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "posix-ptys.patch";
      url =
        "https://git.alpinelinux.org/aports/plain/community/xterm/posix-ptys.patch?id=3aa532e77875fa1db18c7fcb938b16647031bcc1";
      sha256 = "0czgnsxkkmkrk1idw69qxbprh0jb4sw3c24zpnqq2v76jkl7zvlr";
    });

  configureFlags = [
    "--enable-wide-chars"
    "--enable-256-color"
    "--enable-sixel-graphics"
    "--enable-regis-graphics"
    "--enable-load-vt-fonts"
    "--enable-i18n"
    "--enable-doublechars"
    "--enable-luit"
    "--enable-mini-luit"
    "--with-tty-group=tty"
    "--with-app-defaults=$(out)/lib/X11/app-defaults"
  ] ++ lib.optional enableDecLocator "--enable-dec-locator";

  # Work around broken "plink.sh".
  NIX_LDFLAGS = "-lXmu -lXt -lICE -lX11 -lfontconfig";

  # Hack to get xterm built with the feature of releasing a possible setgid of 'utmp',
  # decided by the sysadmin to allow the xterm reporting to /var/run/utmp
  # If we used the configure option, that would have affected the xterm installation,
  # (setgid with the given group set), and at build time the environment even doesn't have
  # groups, and the builder will end up removing any setgid.
  postConfigure = ''
    echo '#define USE_UTMP_SETGID 1'
  '';

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --set XAPPLRESDIR $out/lib/X11/app-defaults/
    done

    install -D -t $out/share/applications xterm.desktop
    install -D -t $out/share/icons/hicolor/48x48/apps icons/xterm-color_48x48.xpm
  '';

  passthru = {
    tests = { inherit (nixosTests) xterm; };

    updateScript = let
      # Tags that end in letters are unstable
      suffixes = lib.concatStringsSep " "
        (map (c: "-c versionsort.suffix='${c}'")
          (lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz"));
    in writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        lib.makeBinPath [
          common-updater-scripts
          git
          nixfmt
          nix
          coreutils
          gnused
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestTag="$(git ${suffixes} ls-remote --exit-code --refs --sort='version:refname' --tags git@github.com:ThomasDickey/xterm-snapshots.git 'xterm-*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^xterm-||g')"

      if [ ! "$oldVersion" = "$latestTag" ]; then
        update-source-version ${pname} "$latestTag" --version-key=version --print-changes
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/applications/terminal-emulators/xterm/default.nix"
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = {
    homepage = "https://invisible-island.net/xterm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nequissimus vrthra ];
    platforms = with lib.platforms; linux ++ darwin;
    changelog = "https://invisible-island.net/xterm/xterm.log.html";
  };
}
