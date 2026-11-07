{
  lib,
  stdenv,
  fetchurl,
  pkgsCross,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iperf";
  version = "2.2.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/iperf-${finalAttrs.version}.tar.gz";
    hash = "sha256-dUqwp+KAM9vqgTCO9CS8ffTW4v4xtgzFNrYbUf772Ps=";
  };

  configureFlags = [ "--enable-fastsampling" ];

  makeFlags = [ "AR:=$(AR)" ];

  postInstall = ''
    mv $out/bin/iperf $out/bin/iperf2
    ln -s $out/bin/iperf2 $out/bin/iperf
  '';

  passthru.tests = {
    cross-aarch64 = pkgsCross.aarch64-multiplatform.iperf2;
  };

  meta = {
    homepage = "https://sourceforge.net/projects/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "iperf2";
    maintainers = with lib.maintainers; [ randomizedcoder ];

    # prioritize iperf3
    priority = 10;
  };
})
