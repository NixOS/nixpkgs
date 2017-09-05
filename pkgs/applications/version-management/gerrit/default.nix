{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gerrit-${version}";
  version = "2.14.3";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    sha256 = "1hxrlhp5l5q4lp5b5bq8va7856cnm4blfv01rgqq3yhvn432sq6v";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1wg7bbhwgi9sxn7skxb9gwaydq9jzpdhglwgq5kihj7r269fmr4k";

  buildCommand = ''
    install -D ${src} "$out"/webapps/gerrit-${version}.war
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gerritcodereview.com/index.md;
    license = licenses.asl20;
    description = "A web based code review and repository management for the git version control system";
    maintainers = with maintainers; [ jammerful ];
    platforms = platforms.unix;
  };
}
