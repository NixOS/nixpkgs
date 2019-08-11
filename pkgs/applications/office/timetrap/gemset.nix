{
  chronic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  sequel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121z4sq2m4vsgxwy8hs6d12cc1i4xa5rjiv0nbviyj87jldxapw0";
      type = "gem";
    };
    version = "4.43.0";
  };
  sqlite3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  timetrap = {
    dependencies = ["chronic" "sequel" "sqlite3"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ylaz9q99hbxnw6h1df6wphmh68fj847d1l4f9jylcx3nzzp5cyd";
      type = "gem";
    };
    version = "1.15.1";
  };
}