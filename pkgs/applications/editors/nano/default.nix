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
    rev = "17e0de65e1cbba3d6baa82deaefa853b41f5c161";
    sha256 = "1g51h65i31andfs2fbp1v3vih9405iknqn11fzywjxji00kjqv5s";
  };

in stdenv.mkDerivation rec {
  name = "nano-${version}";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.xz";
    sha256 = "1hjxr0kgq3q1fcns9y4lj0dbhjf33j3pa2wayrb3p3c8v3sbrh8m";
  };

  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];

  outputs = [ "out" "info" ];

  configureFlags = ''
    --sysconfdir=/etc
    ${optionalString (!enableNls) "--disable-nls"}
    ${optionalString enableTiny "--enable-tiny"}
  ''
  # Unclear why (perhaps an impurity?) but for some reason it decides that REG_ENHANCED is available
  # during configure but then can't find it at build time.
    + optionalString stdenv.isDarwin ''
    nano_cv_flag_reg_extended=REG_EXTENDED
  '';

  postPatch = optionalString stdenv.isDarwin ''
    substituteInPlace src/text.c --replace "__time_t" "time_t"
  '';

  postInstall = ''
    cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
  '';

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jgeerds
      joachifm
    ];
    platforms = platforms.all;
  };
}
