{
  stdenv,
  fetchurl,

  lib,
  cups,
  dpkg,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "evolis-card-printer";
  version = "4.12.8"; # driver version
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    # archive.org used as mirror as evolis does not provide simple download links
    # original copies can be optained at https://myplace.evolis.com/s/product/pebble-4/01t5p00000CXScZAAX?language=en_US&tabset-100fe=2
    # deb drivers have weird problems described on archive.org page
    # TLDR: use portrait as landscape and vice versa

    url = "https://archive.org/download/evolisprinter-4.12.8.8/64%20bit%20version%20-%20evolisprinter-4.12.8.8.amd64.deb";
    hash = "sha256-xldAk9FunkIcStu6hAS6onlRS3JdWIVftkbj8Bxtx8c=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    cups
  ];

  installPhase = ''
    runHook preInstall
    cp -r usr $out
    runHook postInstall
  '';

  meta = {
    description = "Evolis printer drivers, for Pebble, Badgy, Dualys, Primacy, Quantum, Securion, Tattoo, Tatoo2 and Zenus card printers";
    homepage = "https://myplace.evolis.com/s/product/pebble-4/01t5p00000CXScZAAX?language=en_US&tabset-100fe=2";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      kleiner3
    ];
    platforms = [ "x86_64-linux" ];
  };
}
