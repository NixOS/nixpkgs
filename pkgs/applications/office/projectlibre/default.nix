{ stdenv, fetchurl, jre, coreutils, which }:

stdenv.mkDerivation rec {
  name = "projectlibre-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/projectlibre/ProjectLibre/1.7/${name}.tar.gz";
    sha256 = "0h92h8ybn9z9y1ra2lanaac0504h2gpb77kp09lnja6sjvfsgidb";
  };

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib/projectlibre"
    mkdir -p "$out/share/doc/projectlibre"

    cp -R lib \
        projectlibre.jar \
        projectlibre.sh \
        "$out/lib/projectlibre"

    cp -R license "$out/share/doc/projectlibre"

    cat >"$out/bin/projectlibre" << EOF
    #!${stdenv.shell}
    # Add PATH at the end so projectlibre can find a browser
    export "PATH=${jre}/bin:${coreutils}/bin:${which}/bin:\$PATH"
    exec "$out/lib/projectlibre/projectlibre.sh"
    EOF
    chmod +x "$out/bin/projectlibre"
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.projectlibre.com/";
    description = "Open source project management software";
    license = licenses.cpal10;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
