{ callPackage, fetchpatch, fetchzip }:

let
  rev = "7bcf43f8dbd5c4a67ec573a1248114caa75fa3c2";
in
callPackage ./dvtm.nix {
  pname = "dvtm-unstable";
  version = "unstable-2021-03-09";

  src = fetchzip {
    urls = [
      "https://github.com/martanne/dvtm/archive/${rev}.tar.gz"
      "https://git.sr.ht/~martanne/dvtm/archive/${rev}.tar.gz"
    ];
    hash = "sha256-UtkNsW0mvLfbPSAIIZ1yvX9xzIDtiBeXCjhN2R8JhDc=";
  };

  patches = [
    # https://github.com/martanne/dvtm/pull/69
    # Use self-pipe instead of signal blocking fixes issues on darwin.
    (fetchpatch {
      name = "use-self-pipe-fix-darwin";
      url = "https://github.com/martanne/dvtm/commit/1f1ed664d64603f3f1ce1388571227dc723901b2.patch";
      sha256 = "14j3kks7b1v6qq12442v1da3h7khp02rp0vi0qrz0rfgkg1zilpb";
    })
  ];
}
