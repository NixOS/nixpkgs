{ lib, stdenv, fetchzip, makeWrapper, unzip, jre, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "yEd";
  version = "3.21.1";

  src = fetchzip {
    url = "https://www.yworks.com/resources/yed/demo/${pname}-${version}.zip";
    sha256 = "1jw28hkd7p0n660gid8yh5y0kdcz6ycn4hsgjlf0pq48x9kv6w0c";
  };

  nativeBuildInputs = [ makeWrapper unzip wrapGAppsHook ];
  # For wrapGAppsHook setup hook
  buildInputs = [ (jre.gtk3 or null) ];

  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;

  preFixup = ''
    mkdir -p $out/yed
    cp -r * $out/yed
    mkdir -p $out/bin

    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapper ${jre}/bin/java $out/bin/yed \
      ''${makeWrapperArgs[@]} \
      --add-flags "-jar $out/yed/yed.jar --"
  '';
  dontWrapGApps = true;

  meta = with lib; {
    license = licenses.unfree;
    homepage = "https://www.yworks.com/products/yed";
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
