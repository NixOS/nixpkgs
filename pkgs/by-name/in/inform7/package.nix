{
  lib,
  stdenv,
  fetchzip,
  coreutils,
  perl,
  gnutar,
  gzip,
}:
stdenv.mkDerivation {
  pname = "inform7";
  version = "6M62";
  buildInputs = [
    perl
    coreutils
    gnutar
    gzip
  ];
  src = fetchzip {
    url = "http://emshort.com/inform-app-archive/6M62/I7_6M62_Linux_all.tar.gz";
    hash = "sha256-f/ICxCl2VPBMZwXsk7ahD3kV8XF+CEi21x9mm8ElP/Y=";
  };
  preConfigure = "touch Makefile.PL";
  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    pushd $src
    ./install-inform7.sh --prefix $out
    popd

    substituteInPlace "$out/bin/i7" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  meta = {
    description = "Design system for interactive fiction";
    mainProgram = "i7";
    homepage = "http://emshort.com/inform-app-archive";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ mbbx6spp ];
    platforms = lib.platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken =
      (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
      || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
