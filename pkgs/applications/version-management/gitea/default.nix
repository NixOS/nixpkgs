{ stdenv, lib, buildGoPackage, fetchFromGitHub, makeWrapper
, git, coreutils, bash, gzip, openssh
, sqliteSupport ? true
}:

buildGoPackage rec {
  name = "gitea-${version}";
  version = "1.1.3";

  meta = {
    description = "Gitea is a painless self-hosted Git service";
    homepage = "https://gitea.io";
    license = stdenv.lib.licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${version}";
    sha256 = "0lmki6z80b3lny8gqfz1qiwmx68bb2gzkfdzv9xynixp3pyj1zfc";
  };

  goPackagePath = "code.gitea.io/gitea";

  patchPhase = ''
    substituteInPlace models/repo.go \
      --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    substituteInPlace models/migrations/v19.go \
      --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    substituteInPlace  models/migrations/v22.go \
      --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
  '';

  buildInputs = [ makeWrapper ];

  buildFlags = stdenv.lib.optionalString sqliteSupport "-tags sqlite";

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir -p $data/conf
    cp -R $src/options/locale $data/conf
    cp -R $src/{public,templates} $data

    wrapProgram $bin/bin/gitea \
      --prefix PATH : ${stdenv.lib.makeBinPath [ bash git gzip openssh ]} \
      --run 'export GITEA_WORK_DIR=''${GITEA_WORK_DIR:-$PWD}' \
      --run 'mkdir -p "$GITEA_WORK_DIR" && cd "$GITEA_WORK_DIR"' \
      --run "ln -fs $data/{conf,public,templates} ."
  '';

}
