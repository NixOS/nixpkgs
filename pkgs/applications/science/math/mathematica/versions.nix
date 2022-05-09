{ lib, requireFile }:

let versions = [
  {
    version = "13.0.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-NnKpIMG0rxr9SAcz9tZ2Zbr4JYdX3+WabtbXRAzybbo=";
    installer = "Mathematica_13.0.1_BNDL_LINUX.sh";
  }
  {
    version = "13.0.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-FbutOaWZUDEyXR0Xj2OwDnFwbT7JAB66bRaB+8mR0+E=";
    installer = "Mathematica_13.0.0_BNDL_LINUX.sh";
  }
  {
    version = "12.3.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-UbnKsS/ZGwCep61JaKLIpZ6U3FXS5swdcSrNW6LE1Qk=";
    installer = "Mathematica_12.3.1_LINUX.sh";
  }
  {
    version = "12.3.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-BF3wRfbnlt7Vn2TrLg8ZSayI3LodW24F+1PqCkrtchU=";
    installer = "Mathematica_12.3.0_LINUX.sh";
  }
  {
    version = "12.2.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-O2Z2ogPGrbfpxBilSEsDeXQoe1vgnGTn3+p03cDkANc=";
    installer = "Mathematica_12.2.0_LINUX.sh";
  }
  {
    version = "12.1.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-rUe4hr5KmGTXD1I/eSYVoFHU68mH2aD2VLZFtOtDswo=";
    installer = "Mathematica_12.1.1_LINUX.sh";
  }
  {
    version = "12.1.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-56P1KKOTJkQj+K9wppAsnYpej/YB3VUNL7DPLYGgqZY=";
    installer = "Mathematica_12.1.0_LINUX.sh";
  }
  {
    version = "12.0.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-uftx4a/MHXLCABlv+kNFEtII+ikg4geHhDP1BOWK6dc=";
    installer = "Mathematica_12.0.0_LINUX.sh";
  }
  {
    version = "11.3.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-D8/iCMHqyESOe+OvC9uENwsXvZxdBmwBOSjI7pWu0Q4=";
    installer = "Mathematica_11.3.0_LINUX.sh";
  }
  {
    version = "11.2.0";
    lang = "ja";
    language = "Japanese";
    sha256 = "sha256-kWOS7dMr7YYiI430Nd2OhkJrsEMDijM28w3xDYGbSbE=";
    installer = "Mathematica_11.2.0_ja_LINUX.sh";
  }
  {
    version = "9.0.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-mKgxdd7dLWa5EOuR5C37SeU+UC9Cv5YTbY5xSK9y34A=";
    installer = "Mathematica_9.0.0_LINUX.sh";
  }
  {
    version = "10.0.2";
    lang = "en";
    language = "English";
    sha256 = "sha256-NHUg1jzLos1EsIr8TdYdNaA5+3jEcFqVZIr9GVVUXrQ=";
    installer = "Mathematica_10.0.2_LINUX.sh";
  }
];

in

lib.flip map versions ({ version, lang, language, sha256, installer }: {
  inherit version lang;
  src = requireFile {
    name = installer;
    message = ''
      This nix expression requires that ${installer} is
      already part of the store. Find the file on your Mathematica CD
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    inherit sha256;
  };
})
