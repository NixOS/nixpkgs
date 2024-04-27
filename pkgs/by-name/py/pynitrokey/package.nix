{ python3
, fetchPypi
, rustPlatform
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/nxp-mcuxpresso/spsdk/issues/64
      cryptography = super.cryptography.overridePythonAttrs (old: rec {
        version = "41.0.7";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-E/k86b6oAWwlOzSvxr1qdZk+XEBnLtVAWpyDLw1KALw=";
        };
        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = "${old.pname}-${version}/${old.cargoRoot}";
          name = "${old.pname}-${version}";
          hash = "sha256-VeZhKisCPDRvmSjGNwCgJJeVj65BZ0Ge+yvXbZw86Rw=";
        };
        patches = [ ];
        doCheck = false; # would require overriding cryptography-vectors
      });
    };
  };
in with python.pkgs; toPythonApplication pynitrokey
