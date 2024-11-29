{ buildDunePackage, stog, ocf_ppx }:

buildDunePackage {
  pname = "stog_asy";

  inherit (stog) version src;

  buildInputs = [ ocf_ppx ];
  propagatedBuildInputs = [ stog ];

  meta = stog.meta // {
    description = "Stog plugin to include Asymptote results in documents";
  };
}
