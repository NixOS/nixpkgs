{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gerrit-${version}";
  version = "2.14.3";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    sha256 = "db602d06b11bfa81f1cb016c4717a99699828eda08afb2caa504175a2ea4b9c3";
  };

  buildCommand = ''
    mkdir -p "$out"/webapps
    cp "${src}" "$out"/webapps/gerrit-${version}.war
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gerritcodereview.com/index.md;
    license = licenses.asl20;
    description = "A web based code review and repository management for the git version control system";
    maintainers = with maintainers; [ jammerful ];
    platforms = platforms.unix;
  };
}
