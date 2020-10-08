pyPkgs: fetchFromGitHub:
{
  django_2_0 = pyPkgs.django_2_2.overridePythonAttrs (old: rec {
    version = "2.0.12";
    src = pyPkgs.fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "15s8z54k0gf9brnz06521bikm60ddw5pn6v3nbvnl47j1jjsvwz2";
    };
  });

  django_extensions_2_2_8 = pyPkgs.django_extensions.overridePythonAttrs (old: rec {
    version = "2.2.8";
    src = fetchFromGitHub {
      owner = old.pname;
      repo = old.pname;
      rev = version;
      sha256 = "1gd3nykwzh3azq1p9cvgkc3l5dwrv7y86sfjxd9llbyj8ky71iaj";
    };
  });

  factory_boy_2_12_0 = pyPkgs.factory_boy.overridePythonAttrs (old: rec {
    version = "2.12.0";
    src = pyPkgs.fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "0w53hjgag6ad5i2vmrys8ysk54agsqvgbjy9lg8g0d8pi9h8vx7s";
    };
  });
}
