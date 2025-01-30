{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  coreutils,
  gnused,
  gnugrep,
  sqlite,
  wget,
  w3m,
  socat,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "dasht";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "sunaku";
    repo = pname;
    rev = "v${version}";
    sha256 = "08wssmifxi7pnvn9gqrvpzpkc2qpkfbzbhxh0dk1gff2y2211qqk";
  };

  deps = lib.makeBinPath [
    coreutils
    gnused
    gnugrep
    sqlite
    wget
    w3m
    socat
    gawk
    (placeholder "out")
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/* $out/bin/

    installManPage man/man1/*
    installShellCompletion --zsh etc/zsh/completions/*

    for i in $out/bin/*; do
      echo "Wrapping $i"
      wrapProgram $i --prefix PATH : ${deps};
    done;

    runHook postInstall
  '';

  meta = {
    description = "Search API docs offline, in terminal or browser";
    homepage = "https://sunaku.github.io/dasht/man";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix; # cannot test other
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
