{ stdenv, fetchgit, buildPythonPackage
, srht, redis, pyyaml, buildsrht
, writeText }:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.13.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/scm.sr.ht";
    rev = version;
    sha256 = "0bapddgfqrs27y6prd6kwpz6jdlr33zdqr6ci6ixi584a7z8z7d6";
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
    # Validation needs config option(s)
    # webhooks <- ( private-key )
    # meta.sr.ht <- ( origin )
    # builds.sr.ht <- ( origin, oauth-client-id )
    cp ${config} config.ini
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/git.sr.ht;
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
