{
  stdenv,
  lib,
  python3,
  fetchFromGitHub,
  which,
  coreutils,
  perl,
  installShellFiles,
  gnumake42,
  fetchpatch,
  pkg-config,
  gtk2,
  libpng,
  texliveSmall,
  openssl,
  ghostscript,
  rWrapper,
  rPackages,
  cpio,
  debootstrap,
  libeatmydata,
  fakeroot,
  fakechroot,
  doCheck ? true,
}:
let
  allOrNothing = func: list: lib.optionals (lib.all func list) list;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "redo-apenwarr";
  version = "0.42d";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = "redo";
    tag = "redo-${finalAttrs.version}";
    hash = "sha256-/QIMXpVhVLAIJa3LiOlRKzbUztIWZygkWZUKN4Nrh+M=";
  };

  patches = [
    (fetchpatch {
      name = "posix-null-cd.patch";
      url = "https://github.com/magistau/redo/commit/bbad2ed2892ab942796431c5d087c2854daa10d8.diff";
      hash = "sha256-o4MVAzcJdAmB1eIcdjK9hZ1/wWfE1/Yf8jXmm8lFTAs=";
    })
    (fetchpatch {
      name = "shebangs.patch";
      url = "https://github.com/magistau/redo/commit/76214f67e782f9c0bc4926fc053edd1e33992006.diff";
      hash = "sha256-LNuExO5YDYFP3BxPAH07VAPR3VK6D45rOKF/8XXfA5g=";
    })
    (fetchpatch {
      name = "splitwords.patch";
      url = "https://github.com/magistau/redo/commit/9e7a0341692340eac758497a9ec4730c6f91d3b9.diff";
      hash = "sha256-srdMOMuBhZGaFCk+vkJZOOEeGwyxTNg+kpQ3Kan0IGY=";
    })
  ];

  postPatch = lib.optionalString doCheck ''
    unset CC CXX

    substituteInPlace ./do \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace minimal/do \
      --replace-fail "/usr/bin/env" "${coreutils}/bin/env"

    substituteInPlace minimal/do.test \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/105-sympath/all.do \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/all.do \
      --replace-fail "/bin/ls" "ls"

    substituteInPlace t/110-compile/hello.o.do \
      --replace-fail "/usr/include" "${lib.getDev stdenv.cc.libc}/include"

    for recipe in t/200-shell/nonshelltest.do docs/cookbook/container/default.sha256.do; do
      chmod u+x "$recipe"
      patchShebangs "$recipe"
      chmod u-x "$recipe"
    done
    patchShebangs docs/cookbook/container/
  '';

  inherit doCheck;
  checkTarget = "test";

  checkInputs = [
    gtk2
    libpng
    openssl
  ];
  # redo shouldn't fail to build jsut because certain tests require dependencies are not available for a platform
  nativeCheckInputs = [
    perl
    pkg-config
  ]
  ++ lib.concatMap (allOrNothing (lib.meta.availableOn stdenv.buildPlatform)) [
    [
      texliveSmall
      ghostscript
      (rWrapper.override {
        packages = [ rPackages.ggplot2 ];
      })
    ]
    [
      debootstrap
      libeatmydata
    ]
    [
      cpio
    ]
    [
      fakeroot
      fakechroot
    ]
  ];

  outputs = [
    "out"
    "man"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "DESTDIR=/"
  ];

  nativeBuildInputs = [
    (python3.withPackages (ps: [
      ps.beautifulsoup4
      ps.markdown
    ]))
    which
    installShellFiles
    gnumake42 # fails with make 4.4
  ];

  postInstall = ''
    installShellCompletion --bash contrib/bash_completion.d/redo
  '';

  meta = with lib; {
    description = "Smaller, easier, more powerful, and more reliable than make. An implementation of djb's redo";
    homepage = "https://github.com/apenwarr/redo";
    maintainers = with maintainers; [
      andrewchambers
      ck3d
    ];
    license = licenses.asl20;
    platforms = python3.meta.platforms;
  };
})
