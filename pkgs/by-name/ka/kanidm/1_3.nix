import ./generic.nix {
  version = "1.3.3";
  hash = "sha256-W5G7osV4du6w/BfyY9YrDzorcLNizRsoz70RMfO2AbY=";
  cargoHash = "sha256-iziTHr0gvv319Rzgkze9J1H4UzPR7WxMmCkiGVsb33k=";
  patchDir = ./patches/1_3;
  extraMeta = {
    knownVulnerabilities = [
      ''
        kanidm 1.3.x has reached EOL as of 2024-12-01.

        Please upgrade by verifying `kanidmd domain upgrade-check` and setting `services.kanidm.package = pkgs.kanidm_1_4;`
        See upgrade guide at https://kanidm.github.io/kanidm/master/server_updates.html
      ''
    ];
  };
}
