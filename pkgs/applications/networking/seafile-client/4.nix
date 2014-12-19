{ stdenv, fetchurl, writeScript, pkgconfig, qt4, seafile-shared4, ccnet4
, makeWrapper, cmake }:

stdenv.mkDerivation rec
{
  version = "4.0.4";
  name = "seafile-client-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz";
    sha256 = "1xqxqvxg4kd452wk8g2nc40bpaxrhzsbjp1ll7d0asqry4zn89jb";
  };

  buildInputs = [ pkgconfig qt4 seafile-shared4 makeWrapper cmake ];

  configurePhase = ''
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_SKIP_BUILD_RPATH=ON -DCMAKE_INSTALL_PREFIX="$out" .
  '';

  buildPhase = "make -j1";

  postInstall = ''
    wrapProgram $out/bin/seafile-applet \
      --suffix PATH : ${ccnet4}/bin:${seafile-shared4}/bin
  '';

  meta =
  {
    homepage = "https://github.com/haiwen/seafile-clients";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
  };
}
