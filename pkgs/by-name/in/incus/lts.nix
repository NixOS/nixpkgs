import ./generic.nix {
  hash = "sha256-+W4imWem5iQ6nPVcoObc4COFxQVED0ppVd/YC+Nqtgw=";
  version = "6.0.3";
  vendorHash = "sha256-ZUtWzbAjHij95khYx8lWYEpA8ITlMtKpObG5Vl7aE90=";
  patches = [
    # qemu 9.1 compat, remove when added to LTS
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
  ];
  lts = true;
  updateScriptArgs = "--lts --regex '6.0.*'";
}
