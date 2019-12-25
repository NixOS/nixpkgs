{ stdenv, fetchurl, fetchFromGitHub
, ncurses
, texinfo
, gettext ? null
, enableNls ? true
, enableTiny ? false
}:

assert enableNls -> (gettext != null);

with stdenv.lib;

let
  nixSyntaxHighlight = fetchFromGitHub {
    owner = "seitz";
    repo = "nanonix";
    rev = "bf8d898efaa10dce3f7972ff765b58c353b4b4ab";
    sha256 = "0773s5iz8aw9npgyasb0r2ybp6gvy2s9sq51az8w7h52bzn5blnn";
  };

in stdenv.mkDerivation rec {
  pname = "nano";
  version = "4.6";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    sha256 = "1s98jsvkfar6qmd5n5l1n1k59623dnc93ciyvlhxjkvpad0kmb4v";
  };

  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];

  outputs = [ "out" "info" ];

  configureFlags = [
    "--sysconfdir=/etc"
    (stdenv.lib.enableFeature enableNls "nls")
    (stdenv.lib.enableFeature enableTiny "tiny")
  ];

    patches = [
      (fetchurl {
        # fix compilation on macOS, where 'st_mtim' is unknown
        # upstream patch not in 4.6
        url = "https://git.savannah.gnu.org/cgit/nano.git/patch/?id=f516cddce749c3bf938271ef3182b9169ac8cbcc";
        sha256 = "0gqymvr5vxxypr7y3sm252rsi4gjqp597l01x0lkxyvxsn45a4sx";
      })
  ];

  postInstall = ''
    cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      joachifm
    ];
    platforms = platforms.all;
  };
}
