{ stdenv, fetchgit, buildPythonPackage
, srht, redis, pyyaml, buildsrht
, writeText }:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.15.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/scm.sr.ht";
    rev = version;
    sha256 = "1rzm3r280211w51sjngm5a3pdlzg07c64324k99bqs1fkc2yrfy6";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    pyyaml
    buildsrht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  # No actual? tests but seems like it needs this anyway
  preCheck = let
    config = writeText "config.ini" ''
      [webhooks]
      private-key=K6JupPpnr0HnBjelKTQUSm3Ro9SgzEA2T2Zv472OvzI=

      [builds.sr.ht]
      origin=http://builds.sr.ht.local
      oauth-client-id=

      [meta.sr.ht]
      origin=http://meta.sr.ht.local
    '';
  in ''
    cp -f ${config} config.ini
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/git.sr.ht;
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
