{ stdenv
, autoPatchelfHook
, dpkg
, fahviewer
, fetchurl
, makeWrapper
, python2
}:
let
  majMin = stdenv.lib.versions.majorMinor version;
  version = "7.6.13";

  python = python2.withPackages
    (
      ps: [
        ps.pycairo
        ps.pygobject2
        ps.pygtk
      ]
    );
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "fahcontrol";

  src = fetchurl {
    url = "https://download.foldingathome.org/releases/public/release/fahcontrol/debian-stable-64bit/v${majMin}/fahcontrol_${version}-1_all.deb";
    sha256 = "0qfvhwc29cgqkwf2bkhq4gr2d1c4jgccfs58916ss03n4rwz9gng";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [ fahviewer python ];

  doBuild = false;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = "cp -ar usr $out";

  postFixup = ''
    sed -e 's|/usr/bin|$out/bin|g' -i $out/share/applications/FAHControl.desktop
    wrapProgram "$out/bin/FAHControl" \
      --suffix PATH : "${fahviewer.outPath}/bin" \
      --set PYTHONPATH "$out/lib/python2.7/dist-packages"
  '';

  meta = {
    description = "Folding@home control";
    homepage = "https://foldingathome.org/";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
