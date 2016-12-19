{stdenv, fetchurl, writeScript, pkgconfig, cmake, qt4, seafile-shared, ccnet, makeWrapper}:

stdenv.mkDerivation rec
{
  version = "5.0.7";
  name = "seafile-client-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz";
    sha256 = "ae6975bc1adf45d09cf9f6332ceac7cf285f8191f6cf50c6291ed45f8cf4ffa5";
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
      --suffix PATH : ${stdenv.lib.makeBinPath [ ccnet seafile-shared ]}
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
