{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  ncurses,
  texinfo,
  writeScript,
  common-updater-scripts,
  gitMinimal,
  nix,
  coreutils,
  gnused,
  callPackage,
  file ? null,
  gettext ? null,
  enableNls ? true,
  enableTiny ? false,
}:

assert enableNls -> (gettext != null);

let
  nixSyntaxHighlight = fetchFromGitHub {
    owner = "seitz";
    repo = "nanonix";
    rev = "5c30e1de6d664d609ff3828a8877fba3e06ca336";
    hash = "sha256-S9p/g8DZhZ1cZdyFI6eaOxxGAbz+dloFEWdamAHo120=";
  };

in
stdenv.mkDerivation rec {
  pname = "nano";
  version = "8.6";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    hash = "sha256-96v78O7V9XOrUb13pFjzLYL5hZxV6WifgZ2W/hQ3phk=";
  };

  nativeBuildInputs = [ texinfo ] ++ lib.optional enableNls gettext;
  buildInputs = [ ncurses ] ++ lib.optional (!enableTiny) file;

  outputs = [
    "out"
    "info"
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    (lib.enableFeature enableNls "nls")
    (lib.enableFeature enableTiny "tiny")
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "gl_cv_func_strcasecmp_works=yes"
  ];

  postInstall =
    if enableTiny then
      null
    else
      ''
        cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
      '';

  # https://hydra.nixos.org/build/300187289/nixlog/1
  # openat-die.c:57:10: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru = {
    tests = {
      expect = callPackage ./test-with-expect.nix { };
    };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        lib.makeBinPath [
          common-updater-scripts
          gitMinimal
          nix
          coreutils
          gnused
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags git://git.savannah.gnu.org/nano.git '*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"

      if [ ! "$oldVersion" = "$latestTag" ]; then
        update-source-version ${pname} "$latestTag" --version-key=version --print-changes
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = with lib; {
    homepage = "https://www.nano-editor.org/";
    description = "Small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      joachifm
      nequissimus
      sigmasquadron
    ];
    platforms = platforms.all;
    mainProgram = "nano";
  };
}
