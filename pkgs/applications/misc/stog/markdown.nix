{
  buildDunePackage,
  stog,
  ocf_ppx,
  omd,
}:

buildDunePackage {
  pname = "stog_markdown";

  inherit (stog) version src;

  buildInputs = [ ocf_ppx ];
  propagatedBuildInputs = [
    omd
    stog
  ];

  meta = stog.meta // {
    description = "Stog plugin to use markdown syntax";
  };
}
