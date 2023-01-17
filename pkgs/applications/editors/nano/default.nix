{ lib, stdenv, fetchurl, fetchFromGitHub, ncurses, texinfo, writeScript
, common-updater-scripts, git, nix, nixfmt, coreutils, gnused, callPackage
, gettext ? null, enableNls ? true, enableTiny ? false }:

assert enableNls -> (gettext != null);

let
  nixSyntaxHighlight = fetchFromGitHub {
    owner = "seitz";
    repo = "nanonix";
    rev = "bf8d898efaa10dce3f7972ff765b58c353b4b4ab";
    sha256 = "0773s5iz8aw9npgyasb0r2ybp6gvy2s9sq51az8w7h52bzn5blnn";
  };

in stdenv.mkDerivation rec {
  pname = "nano";
  version = "7.1";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    sha256 = "V7p1Hpt1GfD23e5QUgLjh8dd3kQMH3qhuTEMw4FAaDY=";
  };

  nativeBuildInputs = [ texinfo ] ++ lib.optional enableNls gettext;
  buildInputs = [ ncurses ];

  outputs = [ "out" "info" ];

  configureFlags = [
    "--sysconfdir=/etc"
    (lib.enableFeature enableNls "nls")
    (lib.enableFeature enableTiny "tiny")
  ];

  postInstall = ''
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
          nixfmt
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
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joachifm nequissimus ];
    platforms = platforms.all;
  };
}
