{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gerrit-${version}";
  version = "2.14.6";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    sha256 = "0fsqwfsnyb4nbxgb1i1mp0vshl0mk8bwqlddzqr9x2v99mbca28q";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1qrmvqqnlbabqz4yx06vi030ci12v0063iq2palxmbj3whrzv9la";

  buildCommand = ''
    mkdir -p "$out"/webapps/
    ln -s ${src} "$out"/webapps/gerrit-${version}.war
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gerritcodereview.com/index.md;
    license = licenses.asl20;
    description = "A web based code review and repository management for the git version control system";
    maintainers = with maintainers; [ jammerful ];
    platforms = platforms.unix;
  };
}
