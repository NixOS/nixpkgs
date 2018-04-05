{ stdenv, python3, beancount }:

let
  python = python3.override {
    packageOverrides = self: super: {
      uritemplate = super.uritemplate.overridePythonAttrs (oldAttrs: rec {
        version = "0.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1zapwg406vkwsirnzc6mwq9fac4az8brm6d9bp5xpgkyxc5263m3";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.7";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0bxnh977r821b8vy36z81k40pazbxspx4wa9sp4ppanx7cha9sy4";
  };

  doCheck = false;

  propagatedBuildInputs = with python.pkgs;
    [ flask dateutil pygments wheel markdown2 flaskbabel tornado
      click beancount uritemplate httplib2 Babel ];

  meta = {
    homepage    = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

