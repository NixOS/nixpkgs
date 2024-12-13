{
  lib,
  stdenv,
  fetchFromSourcehut,
  hare,
  himitsu,
  zip,
}:

stdenv.mkDerivation rec {
  pname = "himitsu-firefox";
  version = "0.3";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "d6d0fdb30aefc93f6ff7d48e5737557051f1ffea";
    hash = "sha256-5RbNdEGPnfDt1KDeU2LnuRsqqqMRyV/Dh2cgEWkz4vQ=";
  };

  nativeBuildInputs = [
    hare
    zip
  ];

  buildInputs = [
    himitsu
  ];

  preConfigure = ''
    export HARECACHE=$(mktemp -d)
  '';

  buildFlags = [ "LIBEXECDIR=$(out)/libexec" ];

  # Only install the native component; per the docs:
  # > To install the add-on for Firefox ESR, run make install-xpi. Be advised
  # > that this will probably not work. The recommended installation procedure
  # > for the native extension is to install it from addons.mozilla.org instead.
  installTargets = [ "install-native" ];
  installFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/himitsu-firefox";
    description = "Himitsu integration for Firefox";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    inherit (hare.meta) platforms badPlatforms;
    broken = true;
  };
}
