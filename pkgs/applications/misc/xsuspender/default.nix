{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config
, glib, libwnck, procps }:

with lib;

stdenv.mkDerivation rec {
  pname = "xsuspender";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "kernc";
    repo = "xsuspender";
    rev = version;
    sha256 = "03lbga68dxg89d227sdwk1f5xj4r1pmj0qh2kasi2cqh8ll7qv4b";
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
