{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "pru";
  gemdir = ./.;
  exes = [ "pru" ];

  meta = {
    homepage = "https://github.com/grosser/pru";
    description = "Pipeable Ruby";
    longDescription = ''
      pru allows to use Ruby scripts as filters, working as a convenient,
      higher-level replacement of typical text processing tools (like sed, awk,
      grep etc.).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };

  passthru.updateScript = bundlerUpdateScript "pru";
}
