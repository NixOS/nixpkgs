{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pkg-config,
  popt,
  mandoc,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efivar";
  version = "39";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efivar";
    rev = finalAttrs.version;
    hash = "sha256-s/1k5a3n33iLmSpKQT5u08xoj8ypjf2Vzln88OBrqf0=";
  };

  nativeBuildInputs = [
    pkg-config
    mandoc
  ];
  buildInputs = [ popt ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  patches = [
    # fix build with glibc-2.44
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/f521cd7f584c95d8308659ab9d89d750e2bd76da.patch";
      hash = "sha256-I19UIS0tNTsEipuoMQPlTEwih1RrYPz9Q4Wy98u1z0Q=";
    })
  ]
  # fix 32-bit builds
  # Can remove once https://github.com/rhboot/efivar/pull/301 is merged
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/a629c47059e76f971269b76f0f00cee2e991f427.patch";
      hash = "sha256-qdl6EZ6/ovjUQQ7ViIkGQ2BP1eu4pnOwrezZKidSg5A=";
    })
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/05aa7e2030acc2b0386972617dc76fcc268c79b1.patch";
      hash = "sha256-CtodF4t2mHeJ6ajsuxljWsWwPovbISEfAAZJgc4gS0Y=";
    })
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/41ebf550bb206aad6d82022d2f91e846b74bad04.patch";
      hash = "sha256-fAVdtG8To6/pDKiGtvBaCd8rMYZTRh4Td7uVI8/42Rg=";
    })
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/3633172fdace9cd1b233eb997ad4128d102ae010.patch";
      hash = "sha256-lQ/MQ9mwhaTzwnp9PNEYfn6TIC71kIhwGuKSSYdFheA=";
    })
  ];

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
    "bindir=$(bin)/bin"
    "mandir=$(man)/share/man"
    "includedir=$(dev)/include"
    "PCDIR=$(dev)/lib/pkgconfig"
  ];

  meta = {
    description = "Tools and library to manipulate EFI variables";
    homepage = "https://github.com/rhboot/efivar";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Only;
  };
})
