{
  childprocess = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a61922kmvcxyj5l70fycapr87gz1dzzlkfpq85rfqk5vdh3d28p";
      type = "gem";
    };
    version = "0.9.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j8pzj8raxbir5w5k6s7a042sb5k02pg0f8s4na1r5lan901j00p";
      type = "gem";
    };
    version = "1.10.0";
  };
  iniparse = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbik6838gfh5yq9ahh1m7dzszxlk0g7x5lvhb8amk60mafkrgws";
      type = "gem";
    };
    version = "1.4.4";
  };
  overcommit = {
    dependencies = ["childprocess" "iniparse"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jfgpprjkq7hkyk7z0wc8difnnzmvmkin0b3bgsmnh6vvpyrz0mn";
      type = "gem";
    };
    version = "0.46.0";
  };
}