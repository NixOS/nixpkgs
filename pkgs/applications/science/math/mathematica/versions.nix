{ lib, requireFile }:

/*
 * To calculate the hash of an installer, use a command like this:
 *
 *   nix --extra-experimental-features nix-command hash file <installer-file>
 */

let versions = [
  {
    version = "14.0.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-NzMhGQZq6o6V4UdtJxUH/yyP2s7wjTR86SRA7lW7JfI=";
    installer = "Mathematica_14.0.0_LINUX.sh";
  }
  {
    version = "14.0.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-UrcBEg6G6nbVX++X0z0oG5JjieXL0AquAqtjzY5EBn4=";
    installer = "Mathematica_14.0.0_BNDL_LINUX.sh";
  }
  {
    version = "13.3.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-0+mYVGiF4Qn3eiLIoINSHVIqT8GtlBPFRYIOF+nHyQo=";
    installer = "Mathematica_13.3.1_LINUX.sh";
  }
  {
    version = "13.3.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-03R4s05fmTcZnlZIMSI6xlLER58MIoccoCr27F8BXOk=";
    installer = "Mathematica_13.3.1_BNDL_LINUX.sh";
  }
  {
    version = "13.3.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-24MC0O+kBUe3TrwXUb+7QZt8tQHvWVIT8F9B6Ih+4k8=";
    installer = "Mathematica_13.3.0_LINUX.sh";
  }
  {
    version = "13.3.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-91bw7+4ht+7g+eF32BNYf77yEQWyuPffisj4kB63pcI=";
    installer = "Mathematica_13.3.0_BNDL_LINUX.sh";
  }
  {
    version = "13.2.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-GA2k+jvE4mTJsIbMHce5c516h/glHLnXdthEfnNmk0w=";
    installer = "Mathematica_13.2.1_LINUX.sh";
  }
  {
    version = "13.2.1";
    lang = "en";
    language = "English";
    sha256 = "sha256-ZvgG2W/gjQIo4hyXHsGta5FyTslrz/ltOe/ZK/U2Sx8=";
    installer = "Mathematica_13.2.1_BNDL_LINUX.sh";
  }
  {
    version = "13.2.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-T9XOXA6jpgN6bcO/do9sw1L73ABtyxuZCLzftv4Cl6o=";
    installer = "Mathematica_13.2.0_LINUX.sh";
  }
  {
    version = "13.2.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-YRUvl2H9SwpwDZx04ugd7ZnK5G+t88bzAObXsGGVhk0=";
    installer = "Mathematica_13.2.0_BNDL_LINUX.sh";
  }
  {
    version = "13.1.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-GZyUYslx/M4aFI3Pj9Osw3/w79/Jp/4T3mRE277pNuM=";
    installer = "Mathematica_13.1.0_LINUX.sh";
  }
  {
    version = "13.1.0";
    lang = "en";
    language = "English";
    sha256 = "sha256-LIpGAJ3uTkZgjc0YykwusyyHQKlCnTvrZGStFfSOz60=";
    installer = "Mathematica_13.1.0_BNDL_LINUX.sh";
  }
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
