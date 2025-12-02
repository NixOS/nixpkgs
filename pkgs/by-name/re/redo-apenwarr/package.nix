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
  doCheck ? true,
}:
stdenv.mkDerivation rec {

  pname = "redo-apenwarr";
  version = "0.42d";

  src = fetchFromGitHub rec {
    owner = "apenwarr";
    repo = "redo";
    rev = "${repo}-${version}";
    sha256 = "/QIMXpVhVLAIJa3LiOlRKzbUztIWZygkWZUKN4Nrh+M=";
  };

  postPatch = ''

    patchShebangs minimal/do

  ''
  + lib.optionalString doCheck ''
    unset CC CXX

    substituteInPlace minimal/do.test \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/105-sympath/all.do \
      --replace-fail "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/all.do \
      --replace-fail "/bin/ls" "ls"

    substituteInPlace t/110-compile/hello.o.do \
      --replace-fail "/usr/include" "${lib.getDev stdenv.cc.libc}/include"

    substituteInPlace t/200-shell/nonshelltest.do \
      --replace-fail "/usr/bin/env perl" "${perl}/bin/perl"

    # See https://github.com/apenwarr/redo/pull/47
    substituteInPlace minimal/do \
      --replace-fail 'cd "$dodir"' 'cd "''${dodir:-.}"'
  '';

  inherit doCheck;

  checkTarget = "test";

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
      ck3d
    ];
    license = licenses.asl20;
    platforms = python3.meta.platforms;
  };
}
