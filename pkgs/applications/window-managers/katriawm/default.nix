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
  version = "23.06";

  src = fetchzip {
    name = finalAttrs.pname + "-" + finalAttrs.version;
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-4vdBX5biakoxiOyz7DPNgkLxlzi27kZ9rC20g+pn3N4=";
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

  meta = {
    homepage = "https://www.uninformativ.de/git/katriawm/file/README.html";
    description = "A non-reparenting, dynamic window manager with decorations";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
