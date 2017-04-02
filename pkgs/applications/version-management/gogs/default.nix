{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, coreutils, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gogs-${version}";
  version = "0.10.18";

  src = fetchFromGitHub {
    owner = "gogits";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "1f1dlickjpdilf4j295i9v2h4ig4pf5d2mnpbr59wh14bby4bh0y";
  };

  patchPhase = ''
    patchShebangs .
    '';

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = optionalString sqliteSupport "-tags sqlite";

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates} $data

    wrapProgram $bin/bin/gogs \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]} \
      --run 'export GOGS_WORK_DIR=''${GOGS_WORK_DIR:-$PWD}' \
      --run 'mkdir -p "$GOGS_WORK_DIR" && cd "$GOGS_WORK_DIR"' \
      --run "ln -fs $data/{public,templates} ."
  '';

  goPackagePath = "github.com/gogits/gogs";
  goDeps = ./deps.nix;

  meta = {
    description = "A painless self-hosted Git service";
    homepage = "https://gogs.io";
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
  };
}
