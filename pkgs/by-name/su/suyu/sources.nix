{
  fetchgit,
  fetchFromGitHub,
  fetchurl,
}:

{
  suyu = let
    self = {
      pname = "suyu-sources";
      version = "0.0.3";
      src = fetchgit {
        url = "https://git.suyu.dev/suyu/suyu";
        rev = "v${self.version}";
        hash = "sha256-wLUPNRDR22m34OcUSB1xHd+pT7/wx0pHYAZj6LnEN4g=";
      };
    };
  in
    self;

  compat-list = {
    pname = "yuzu-compatibility-list";
    version = "0-unstable-2024-02-26";

    src = fetchFromGitHub {
      owner = "flathub";
      repo = "org.yuzu_emu.yuzu";
      rev = "9c2032a3c7e64772a8112b77ed8b660242172068";
      hash = "sha256-ITh/W4vfC9w9t+TJnPeTZwWifnhTNKX54JSSdpgaoBk=";
    };
  };

  nx_tzdb = {
    pname = "nx_tzdb";
    version = "221202";

    src = fetchurl {
      url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
      hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
    };
  };
}
