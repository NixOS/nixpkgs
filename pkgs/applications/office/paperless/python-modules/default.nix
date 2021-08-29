pyPkgs: fetchFromGitHub:
{
  factory_boy_2_12_0 = pyPkgs.factory_boy.overridePythonAttrs (old: rec {
    version = "2.12.0";
    src = pyPkgs.fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "0w53hjgag6ad5i2vmrys8ysk54agsqvgbjy9lg8g0d8pi9h8vx7s";
    };
  });
}
