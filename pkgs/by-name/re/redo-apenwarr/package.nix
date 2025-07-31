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
  tetex,
  openssl,
  ghostscript,
  doCheck ? true,
}:
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
      url = "https://github.com/magistau/redo/commit/bbad2ed2892ab942796431c5d087c2854daa10d8.diff";
      hash = "sha256-o4MVAzcJdAmB1eIcdjK9hZ1/wWfE1/Yf8jXmm8lFTAs=";
    })
    (fetchpatch {
      url = "https://github.com/magistau/redo/commit/76214f67e782f9c0bc4926fc053edd1e33992006.diff";
      hash = "sha256-LNuExO5YDYFP3BxPAH07VAPR3VK6D45rOKF/8XXfA5g=";
    })
  ];

  postPatch = lib.optionalString doCheck ''
    unset CC CXX

    substituteInPlace minimal/do.test \
      --replace-warn "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/105-sympath/all.do \
      --replace-warn "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/all.do \
      --replace-warn "/bin/ls" "ls"

    substituteInPlace t/110-compile/hello.o.do \
      --replace-warn "/usr/include" "${lib.getDev stdenv.cc.libc}/include"

    substituteInPlace t/200-shell/nonshelltest.do \
      --replace-warn "/usr/bin/env perl" "${perl}/bin/perl"
  '';

  inherit doCheck;
  checkTarget = "test";

  nativeCheckInputs = [
    pkg-config
  ];
  checkInputs = [
    gtk2
    libpng
    tetex
    openssl
    ghostscript
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
    python3
    (with python3.pkgs; [
      beautifulsoup4
      markdown
    ])
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
