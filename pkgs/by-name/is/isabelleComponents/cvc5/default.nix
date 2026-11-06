{
  pkgs,
  libpoly,
  symfpu,
  fetchFromGitHub,
  writeTextFile,
}:
(pkgs.cvc5.override {
  libpoly = libpoly.overrideAttrs {
    version = "0.2.0";
    __intentionallyOverridingVersion = true;
  };
  symfpu = symfpu.overrideAttrs {
    version = "0-unstable-2019-05-17";
    __intentionallyOverridingVersion = true;
  };
}).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      version = "1.2.0";
      src = fetchFromGitHub {
        owner = "cvc5";
        repo = "cvc5";
        tag = "cvc5-1.2.0";
        hash = "sha256-Um1x+XgQ5yWSoqtx1ZWbVAnNET2C4GVasIbn0eNfico=";
      };

      passthru.settings = writeTextFile {
        name = "cvc5-settings";
        text = ''
          CVC5_HOME=${finalAttrs.finalPackage}
          CVC5_VERSION=${finalAttrs.version}
          CVC5_SOLVER=${finalAttrs.finalPackage}/bin/cvc5
          CVC5_INSTALLED=yes
        '';
        destination = "/etc/settings";
      };
    }
  )
