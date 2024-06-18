{ lib, stdenv, libressl, fetchzip, pkg-config, sqlite }:

stdenv.mkDerivation rec {
  pname = "litterbox";
  version = "1.9";

  src = fetchzip {
    url = "https://git.causal.agency/litterbox/snapshot/litterbox-${version}.tar.gz";
    hash = "sha256-w4qW7J5CKm+hXHsNNbl9roBslHD14JOe0Nj5WntETqM=";
  };

  buildInputs = [ libressl sqlite ];

  nativeBuildInputs = [ pkg-config ];

  strictDeps = true;

  buildFlags = [ "all" ];

  meta = with lib; {
    description = "Simple TLS-only IRC logger";
    homepage = "https://code.causal.agency/june/litterbox";
    license = licenses.gpl3Plus;
    mainProgram = "litterbox";
    maintainers = with maintainers; [ ajwhouse ];
    platforms = platforms.linux;
  };
}
