{
  buildDunePackage,
  camlp-streams,
  optint,
  alcotest,
  uri,
  base64,
  seppo,
}:

buildDunePackage {
  pname = "mcdb";

  inherit (seppo) version src;

  propagatedBuildInputs = [
    camlp-streams
    optint
  ];

  checkInputs = [
    alcotest
    uri
    base64
  ];
}
