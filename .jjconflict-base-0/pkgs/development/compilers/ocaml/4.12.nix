import ./generic.nix {
  major_version = "4";
  minor_version = "12";
  patch_version = "1";
  sha256 = "1jbjjnmqq6ymsy81x188i256bz4z5jrz1pws8g1qf59c32ganjkf";
  patches = [
    { url = "https://src.fedoraproject.org/rpms/ocaml/raw/129153b85109944bf0b2922949f77ef8f32b39a1/f/0004-Dynamically-allocate-the-alternate-signal-stack-1026.patch";
      sha256 = "sha256-FdQ1HkMKHU9QvgLPUBvMdPiEa7w7IL3+1F3SLv63Gog=";
    }
  ];
}
