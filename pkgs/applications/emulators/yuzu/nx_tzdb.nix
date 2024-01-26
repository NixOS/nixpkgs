{ stdenv, fetchurl, gitUpdater }:
stdenv.mkDerivation rec {
  pname = "nx_tzdb";
  version = "221202";

  src = fetchurl {
    url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
    hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
  };

  dontUnpack = true;

  buildCommand = ''
    cp $src $out
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/lat9nq/tzdb_to_nx.git";
  };
}
