{ lib
, stdenv
, fetchzip
, libX11
, libXft
, libXrandr
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katriawm";
  version = "21.09";

  src = fetchzip {
    name = finalAttrs.pname + "-" + finalAttrs.version;
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-xt0sWEwTcCs5cwoB3wVbYcyAKL0jx7KyeCefEBVFhH8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXft
    libXrandr
  ];

  preBuild = ''
    cd src
  '';

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://www.uninformativ.de/git/katriawm/file/README.html";
    description = "A non-reparenting, dynamic window manager with decorations";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
