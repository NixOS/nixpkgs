import ./generic.nix {
  hash = "sha256-8GgzMiXn/78HkMuJ49cQA9BEQVAzPbG7jOxTScByR6Q=";
  version = "6.0.1";
  vendorHash = "sha256-dFg3LSG/ao73ODWcPDq5s9xUjuHabCMOB2AtngNCrlA=";
  patches = [
    # qemu 9.1 compat, remove when added to LTS
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./58eeb4eeee8a9e7f9fa9c62443d00f0ec6797078.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
  ];
  lts = true;
  updateScriptArgs = "--lts=true --regex '6.0.*'";
}
