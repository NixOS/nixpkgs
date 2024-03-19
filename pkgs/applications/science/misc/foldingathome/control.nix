{ lib, stdenv
, dpkg
, fahviewer
, fetchurl
, makeWrapper
, python2
}:
let
  majMin = lib.versions.majorMinor version;
  version = "7.6.21";

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
    sha256 = "1vfrdqkrvdlyxaw3f6z92w5dllrv6810lmf8yhcmjcwmphipvf71";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [ fahviewer python ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = "cp -ar usr $out";

  postFixup = ''
    sed -e "s|/usr/bin|$out/bin|g" -i $out/share/applications/FAHControl.desktop
    wrapProgram "$out/bin/FAHControl" \
      --suffix PATH : "${fahviewer.outPath}/bin" \
      --set PYTHONPATH "$out/lib/python2.7/dist-packages"
  '';

  meta = {
    description = "Folding@home control";
    homepage = "https://foldingathome.org/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
