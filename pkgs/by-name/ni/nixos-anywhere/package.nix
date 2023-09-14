{ stdenv
, fetchFromGitHub
, openssh
, gitMinimal
, rsync
, nix
, coreutils
, curl
, gnugrep
, gawk
, findutils
, gnused
, lib
, makeWrapper
}:
let
  runtimeDeps = [
    gitMinimal # for git flakes
    rsync
    nix
    coreutils
    curl # when uploading tarballs
    gnugrep
    gawk
    findutils
    gnused # needed by ssh-copy-id
  ];
in
stdenv.mkDerivation rec {
  pname = "nixos-anywhere";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nixos-anywhere";
    rev = version;
    hash = "sha256-zM+N7+XDR34DuTrVLJd7Ggq1JPlURddsqNOjXY/rcQM=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -D -m 0755 src/nixos-anywhere.sh $out/bin/nixos-anywhere

    # We prefer the system's openssh over our own, since it might come with features not present in ours:
    # https://github.com/numtide/nixos-anywhere/issues/62
    wrapProgram $out/bin/nixos-anywhere \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} --suffix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = with lib; {
    description = "Install nixos everywhere via ssh";
    homepage = "https://github.com/numtide/nixos-anywhere";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.mic92 maintainers.lassulus maintainers.phaer ];
  };
}
