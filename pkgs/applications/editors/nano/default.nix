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
  version = "4.5";

  src = fetchurl {
    url = "mirror://gnu/nano/${pname}-${version}.tar.xz";
    sha256 = "0czmz1yq8s5qcxcmfjdxzg9nkhbmlc9q1nz04jvf57fdbs7w7mfy";
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
