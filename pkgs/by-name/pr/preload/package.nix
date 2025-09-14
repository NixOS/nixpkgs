{
  lib,
  stdenv,
  fetchzip,
  autoconf,
  automake,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "preload";
  version = "0.6.4";

  src = fetchzip {
    url = "mirror://sourceforge/preload/preload-${version}.tar.gz";
    hash = "sha256-vAIaSwvbUFyTl6DflFhuSaMuX9jPVBah+Nl6c/fUbAM=";
  };

  patches = [
    # Prevents creation of /var directories on build
    ./0001-prevent-building-to-var-directories.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];
  buildInputs = [ glib ];

  configureFlags = [ "--localstatedir=/var" ];

  postInstall = ''
    make sysconfigdir=$out/etc/conf.d install
  '';

  meta = {
    description = "Makes applications run faster by prefetching binaries and shared objects";
    homepage = "https://sourceforge.net/projects/preload";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "preload";
    maintainers = with lib.maintainers; [ ldprg ];
  };
}
