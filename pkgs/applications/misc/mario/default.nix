{ lib, poetry2nix, fetchFromGitHub, python3Packages }:

poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  src = python3Packages.fetchPypi {
    pname = "mario";
    version = "v0.0.155";
    sha256 = "0ks95wchym32bv6h8cdqzzx67z5f46gxhc1k704w58i74vygm8p1";
  };

  overrides = poetry2nix.overrides.withDefaults (self: super: {

    automat = super.automat.overridePythonAttrs
      (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ self.m2r ]; });

    async-generator = self.async_generator;

    async_generator =
      super.async_generator.overridePythonAttrs (old: { doCheck = false; });

    async_exit_stack = self.async-exit-stack;

    cffi = python3Packages.cffi;

    d2to1 = let
      pname = "d2to1";
      version = "0.2.12.post1";
    in python3Packages.buildPythonPackage {
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256:09fq7pq1z8d006xh5z75rm2lk61v6yn2xhy53z4gsgibhqb2vvs9";
      };
      nativeBuildInputs = [ self.setuptools-scm ];
      checkInputs = [ self.nose ];
    };

    docshtest = super.docshtest.overridePythonAttrs
      (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ self.d2to1 ]; });

    importlib_metadata = self.importlib-metadata;

    sphinx_rtd_theme = self.sphinx-rtd-theme;

    trio_typing = self.trio-typing;

  });

  meta = {
    homepage = "https://github.com/python-mario/mario";
    description = "Python pipelines for your shell";
    licenses = with lib.licenses; [ gpl3 ];
    platforms = with lib.platforms; [ darwin unix ];
    maintainers = with lib.maintainers; [ python-mario ];
  };
}
