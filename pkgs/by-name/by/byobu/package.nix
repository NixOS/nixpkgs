{
  lib,
  autoreconfHook,
  bc,
  fetchFromGitHub,
  gettext,
  makeWrapper,
  perl,
  python3,
  screen,
  stdenv,
  vim,
  tmux,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ snack ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "byobu";
  version = "6.13";

  src = fetchFromGitHub {
    owner = "dustinkirkland";
    repo = "byobu";
    rev = finalAttrs.version;
    hash = "sha256-h+3BEMfBRozmpqFNRyfKzjKgevaYm8v7DsJMwkhiCQ4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
  ];

  buildInputs = [
    perl # perl is needed for `lib/byobu/include/*` scripts
    screen
    tmux
  ];

  doCheck = true;
  strictDeps = true;

  postPatch = ''
    for file in usr/bin/byobu-export.in usr/lib/byobu/menu; do
      substituteInPlace $file \
        --replace "gettext" "${gettext}/bin/gettext"
    done
  '';

  postInstall = ''
    # By some reason the po files are not being compiled
    for po in po/*.po; do
      lang=''${po#po/}
      lang=''${lang%.po}
      # Path where byobu looks for translations, as observed in the source code
      # and strace
      mkdir -p $out/share/byobu/po/$lang/LC_MESSAGES/
      msgfmt --verbose $po -o $out/share/byobu/po/$lang/LC_MESSAGES/byobu.mo
    done

    # Override the symlinks, otherwise they mess with the wrapping
    cp --remove-destination $out/bin/byobu $out/bin/byobu-screen
    cp --remove-destination $out/bin/byobu $out/bin/byobu-tmux

    for file in $out/bin/byobu*; do
      # We don't use the usual "-wrapped" suffix because arg0 within the shebang
      # scripts points to the filename and byobu matches against this to know
      # which backend to start with
      bname="$(basename $file)"
      mv "$file" "$out/bin/.$bname"
      makeWrapper "$out/bin/.$bname" "$out/bin/$bname" \
        --argv0 $bname \
        --prefix PATH ":" "$out/bin" \
        --set BYOBU_PATH ${
          lib.makeBinPath [
            vim
            bc
          ]
        } \
        --set BYOBU_PYTHON "${pythonEnv}/bin/python"
    done
  '';

  meta = {
    homepage = "https://www.byobu.org/";
    description = "Text-based window manager and terminal multiplexer";
    longDescription = ''
      Byobu is a text-based window manager and terminal multiplexer. It was
      originally designed to provide elegant enhancements to the otherwise
      functional, plain, practical GNU Screen, for the Ubuntu server
      distribution. Byobu now includes an enhanced profiles, convenient
      keybindings, configuration utilities, and toggle-able system status
      notifications for both the GNU Screen window manager and the more modern
      Tmux terminal multiplexer, and works on most Linux, BSD, and Mac
      distributions.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "byobu";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
