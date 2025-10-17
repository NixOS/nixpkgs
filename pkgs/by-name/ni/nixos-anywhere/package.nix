{
  stdenv,
  fetchFromGitHub,
  openssh,
  gitMinimal,
  nix,
  coreutils,
  curl,
  gnugrep,
  gawk,
  findutils,
  gnused,
  lib,
  makeWrapper,
  sshpass,
  gnutar,
}:
let
  runtimeDeps = [
    gitMinimal # for git flakes
    nix
    coreutils
    curl # when uploading tarballs
    gnugrep
    gawk
    findutils
    gnused # needed by ssh-copy-id
    sshpass # used to provide password for ssh-copy-id
    gnutar # used to upload extra-files
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-anywhere";
  version = "1.12.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-anywhere";
    rev = finalAttrs.version;
    hash = "sha256-rmmlgBlBnadD2pDKqDZeMm0IwZMekbFtdQ7R4cZmQfk=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -D -m 0755 src/nixos-anywhere.sh $out/bin/nixos-anywhere
    install -D -m 0755 src/get-facts.sh $out/bin/get-facts.sh

    # We prefer the system's openssh over our own, since it might come with features not present in ours:
    # https://github.com/nix-community/nixos-anywhere/issues/62
    wrapProgram $out/bin/nixos-anywhere \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} --suffix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = with lib; {
    description = "Install nixos everywhere via ssh";
    homepage = "https://github.com/nix-community/nixos-anywhere";
    mainProgram = "nixos-anywhere";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [
      maintainers.mic92
      maintainers.lassulus
      maintainers.phaer
      maintainers.Enzime
    ];
  };
})
