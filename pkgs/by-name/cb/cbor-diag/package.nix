{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "cbor-diag";

  gemdir = ./.;

  exes = [
    "cbor2diag.rb"
    "cbor2json.rb"
    "cbor2pretty.rb"
    "cbor2yaml.rb"
    "cborseq2diag.rb"
    "cborseq2json.rb"
    "cborseq2neatjson.rb"
    "cborseq2yaml.rb"
    "diag2cbor.rb"
    "diag2pretty.rb"
    "json2cbor.rb"
    "json2pretty.rb"
    "pretty2cbor.rb"
    "pretty2diag.rb"
    "yaml2cbor.rb"
  ];

  passthru.updateScript = bundlerUpdateScript "cbor-diag";

  meta = {
    description = "CBOR diagnostic utilities";
    homepage = "https://github.com/cabo/cbor-diag";
    license = with lib.licenses; asl20;
    maintainers = with lib.maintainers; [
      fdns
      nicknovitski
      amesgen
    ];
    platforms = lib.platforms.unix;
  };
}
