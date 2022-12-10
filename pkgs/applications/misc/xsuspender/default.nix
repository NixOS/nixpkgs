{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config
, glib, libwnck, procps }:

with lib;

stdenv.mkDerivation rec {
  pname = "xsuspender";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "kernc";
    repo = "xsuspender";
    rev = version;
    sha256 = "1c6ab1s9bbkjbmcfv2mny273r66dlz7sgxsmzfwi0fm2vcb2lwim";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [ glib libwnck ];

  postInstall = ''
    wrapProgram $out/bin/xsuspender \
      --prefix PATH : "${makeBinPath [ procps ]}"
  '';

  meta = {
    description = "Auto-suspend inactive X11 applications";
    homepage = "https://kernc.github.io/xsuspender/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
