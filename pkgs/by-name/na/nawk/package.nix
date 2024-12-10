{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  buildPackages,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nawk";
  version = "20240422";

  src = fetchFromGitHub {
    owner = "onetrueawk";
    repo = "awk";
    rev = finalAttrs.version;
    hash = "sha256-wsRkSXCLtK2jk4gW/Lpg/14NiOUANfmCrYqeKZW6CLY=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    bison
    installShellFiles
  ];

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${if stdenv.buildPlatform.isDarwin then "clang" else "cc"}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 a.out "$out/bin/nawk"
    mv awk.1 nawk.1
    installManPage nawk.1
    runHook postInstall
  '';

  meta = {
    homepage = "https://awk.dev";
    description = "The one, true implementation of AWK";
    longDescription = ''
      This is the version of awk described in "The AWK Programming Language",
      Second Edition, by Al Aho, Brian Kernighan, and Peter Weinberger
      (Addison-Wesley, 2023, ISBN 0-13-826972-6).
    '';
    changelog = "https://github.com/onetrueawk/awk/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.mit;
    mainProgram = "nawk";
    maintainers = with lib.maintainers; [
      AndersonTorres
      konimex
    ];
    platforms = lib.platforms.all;
  };
})
