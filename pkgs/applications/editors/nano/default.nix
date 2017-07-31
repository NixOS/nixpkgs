{ stdenv, hostPlatform, fetchurl, fetchFromGitHub
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
  version = "2.8.6";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.xz";
    sha256 = "0xjpm2ka56x5ycrgjh06v110na13xlbm42bs8qibk7g578m9cils";
  };

  patches = stdenv.lib.optional hostPlatform.isDarwin stdenv.secure-format-patch;

  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];

  outputs = [ "out" "info" ];

  configureFlags = ''
    --sysconfdir=/etc
    ${optionalString (!enableNls) "--disable-nls"}
    ${optionalString enableTiny "--enable-tiny"}
  '';

  postInstall = ''
    cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
  '';

  meta = {
    homepage = https://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jgeerds
      joachifm
    ];
    platforms = platforms.all;
  };
}
