{ lib, stdenv, fetchFromGitHub, pkg-config, glib, mpv-unwrapped }:

stdenv.mkDerivation rec {
  pname = "mpv-mpris";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "sha256-leW7oCWTnJuprVnJJ+iXd3nuB2VXl3fw8FmPxv7d6rA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib mpv-unwrapped ];

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
  };
}
