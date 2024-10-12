{ lib, stdenv, fetchurl, fetchFromGitHub, ncurses, texinfo, writeScript
, common-updater-scripts, git, nix, nixfmt-classic, coreutils, gnused
, callPackage, file ? null, gettext ? null, enableNls ? true, enableTiny ? false
}:

assert enableNls -> (gettext != null);

let
  nixSyntaxHighlight = fetchFromGitHub {
    owner = "seitz";
    repo = "nanonix";
    rev = "bf8d898efaa10dce3f7972ff765b58c353b4b4ab";
    hash = "sha256-1tJV7F+iwMPRV6FgnbTw+5m7vMhgaeXftYkr9GPR4xw=";
  };

in stdenv.mkDerivation rec {
  pname = "nano";
  version = "8.2";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    hash = "sha256-1a0H3YYvrK4DBRxUxlNeVMftdAcxh4P8rRrS1wdv/+s=";
  };

  nativeBuildInputs = [ texinfo ] ++ lib.optional enableNls gettext;
  buildInputs = [ ncurses ] ++ lib.optional (!enableTiny) file;

  outputs = [ "out" "info" ];

  configureFlags = [
    "--sysconfdir=/etc"
    (lib.enableFeature enableNls "nls")
    (lib.enableFeature enableTiny "tiny")
  ];

  postInstall = if enableTiny then
    null
  else ''
    cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
  '';

  enableParallelBuilding = true;

  passthru = {
    tests = { expect = callPackage ./test-with-expect.nix { }; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        lib.makeBinPath [
          common-updater-scripts
          git
          nixfmt-classic
          nix
          coreutils
          gnused
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags git://git.savannah.gnu.org/nano.git '*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"

      if [ ! "$oldVersion" = "$latestTag" ]; then
        update-source-version ${pname} "$latestTag" --version-key=version --print-changes
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/applications/editors/nano/default.nix"
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = with lib; {
    homepage = "https://www.nano-editor.org/";
    description = "Small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joachifm nequissimus ];
    platforms = platforms.all;
    mainProgram = "nano";
  };
}
