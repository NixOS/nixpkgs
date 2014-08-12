{stdenv, fetchurl, writeScript, pkgconfig, cmake, qt4, seafile-shared, ccnet, makeWrapper}:

stdenv.mkDerivation rec
{
  version = "3.0.4";
  name = "seafile-client-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz";
    sha256 = "10iz45y8j5f9smi0srxw62frb97vhr0w938v8w3rsjcw9qq366a2";
  };

  buildInputs = [ pkgconfig cmake qt4 seafile-shared makeWrapper ];

  builder = writeScript "${name}-builder.sh" ''
    source $stdenv/setup

    tar xvfz $src
    cd seafile-client-*

    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_SKIP_BUILD_RPATH=ON -DCMAKE_INSTALL_PREFIX="$out" .
    make -j1

    make install

    wrapProgram $out/bin/seafile-applet \
      --suffix PATH : ${ccnet}/bin:${seafile-shared}/bin
    '';

  meta =
  {
    homepage = "https://github.com/haiwen/seafile-clients";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
