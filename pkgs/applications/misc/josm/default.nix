{ lib, stdenv, fetchurl, fetchsvn, makeWrapper, unzip, jre, libXxf86vm }:
let
  pname = "josm";
  version = "17702";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      sha256 = "1p7p0jd87sxrs5n0r82apkilx0phgmjw7vpdg8qrr5msda4rsmpk";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macos-${version}-java16.zip";
      sha256 = "0r17cphxm852ykb8mkil29rr7sb0bj5w69qd5wz8zf2f9djk9npk";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "1b7dryvakph8znh2ahgywch66l4bl5rmgsr79axnz1xi12g8ac12";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ jre ];

  installPhase =
    if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      ${unzip}/bin/unzip ${srcs.macosx} 'JOSM.app/*' -d $out/Applications
    '' else ''
      install -Dm644 ${srcs.jar} $out/share/josm/josm.jar
      cp -R ${srcs.pkg}/usr/share $out

      # Add libXxf86vm to path because it is needed by at least Kendzi3D plugin
      makeWrapper ${jre}/bin/java $out/bin/josm \
        --add-flags "-Djosm.restart=true -Djava.net.useSystemProxies=true" \
        --add-flags "-jar $out/share/josm/josm.jar" \
        --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'
    '';

  meta = with lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rycee sikmir ];
    platforms = platforms.all;
  };
}
