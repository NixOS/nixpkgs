{ lib, stdenv, fetchFromGitHub, pkg-config, glib, mpv-unwrapped }:

stdenv.mkDerivation rec {
  pname = "mpv-mpris";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "sha256-7kPpCfiWe58V4fBOsEVvGoGeNIlMUAyD1fqS5/8k/e4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib mpv-unwrapped ];

  postPatch = ''
    substituteInPlace Makefile --replace 'PKG_CONFIG =' 'PKG_CONFIG ?='
  '';

  installFlags = [ "SCRIPTS_DIR=$(out)/share/mpv/scripts" ];

  # Otherwise, the shared object isn't `strip`ped. See:
  # https://discourse.nixos.org/t/debug-why-a-derivation-has-a-reference-to-gcc/7009
  stripDebugList = [ "share/mpv/scripts" ];
  passthru.scriptName = "mpris.so";

  meta = with lib; {
    description = "MPRIS plugin for mpv";
    homepage = "https://github.com/hoyon/mpv-mpris";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
    changelog = "https://github.com/hoyon/mpv-mpris/releases/tag/${version}";
  };
}
