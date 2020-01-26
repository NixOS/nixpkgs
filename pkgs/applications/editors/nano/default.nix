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
  version = "4.7";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    sha256 = "1x9nqy2kgaz6087p63i71gdjsqbdc9jjpx1ymlyclfakvsby3h2q";
  };

  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];

  outputs = [ "out" "info" ];

  configureFlags = [
    "--sysconfdir=/etc"
    (stdenv.lib.enableFeature enableNls "nls")
    (stdenv.lib.enableFeature enableTiny "tiny")
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
