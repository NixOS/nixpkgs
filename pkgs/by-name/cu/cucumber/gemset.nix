{
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  cucumber = {
    dependencies = [
      "builder"
      "cucumber-ci-environment"
      "cucumber-core"
      "cucumber-cucumber-expressions"
      "cucumber-gherkin"
      "cucumber-html-formatter"
      "cucumber-messages"
      "diff-lcs"
      "mini_mime"
      "multi_test"
      "sys-uname"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+kFhORSFvKFTYoccBMJB6MdhWA0K1S7FRwM2js0LcTE=";
      type = "gem";
    };
    version = "9.2.1";
  };
  cucumber-ci-environment = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u24/zshcmB3/RWGZfoZ1pxI+6tX+nlh9KtdWitvhhjE=";
      type = "gem";
    };
    version = "10.0.1";
  };
  cucumber-core = {
    dependencies = [
      "cucumber-gherkin"
      "cucumber-messages"
      "cucumber-tag-expressions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4Bwo1ljcCo1YBFB+C2O1i6Dk++jn1Q+PGcF7RIcsU0Q=";
      type = "gem";
    };
    version = "13.0.3";
  };
  cucumber-cucumber-expressions = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ob6d8eXXh/Yv+J5alsmnji47mJzve/aY8izV79aZ05E=";
      type = "gem";
    };
    version = "17.1.0";
  };
  cucumber-gherkin = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LmqCEsHQEH+V11CC6L1fBazk5C3Xejlse3E746gGdxg=";
      type = "gem";
    };
    version = "27.0.0";
  };
  cucumber-html-formatter = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1um2LZCEP/lN3t6mk3WdUqrAsibAnHuBmkvKeJ95bqE=";
      type = "gem";
    };
    version = "21.9.0";
  };
  cucumber-messages = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0IpsIoZ13QNolr6+gqKXUMvcTazUYeOe3RGZ36Ntpxk=";
      type = "gem";
    };
    version = "22.0.0";
  };
  cucumber-tag-expressions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-95Dk6CC4DUU+g8akYu1t42uUd7BGVDMi9kbB6MJ1kW0=";
      type = "gem";
    };
    version = "6.1.2";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-muDSy6fU3zB1/ozYYCqGBJk+/A36k0z/Volp77GQmWI=";
      type = "gem";
    };
    version = "1.6.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KXI1hC5ZR8wwNuvmQHdYS/9YPNek6U6aAv3sOZ70baY=";
      type = "gem";
    };
    version = "1.17.2";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_test = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6eVQzdhj+3K+z+NErv3NTL0m6/MHhH9KbAOaQIIyTRA=";
      type = "gem";
    };
    version = "1.1.0";
  };
  sys-uname = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t7PrgXqd1KLyaothak8VCrG3n0aC11OM65ksi3NG9Jw=";
      type = "gem";
    };
    version = "1.3.1";
  };
}
