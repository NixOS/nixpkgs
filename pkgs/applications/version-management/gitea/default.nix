{ lib, buildGoPackage, fetchurl, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
, nixosTests
}:

with lib;

buildGoPackage rec {
  pname = "gitea";
  version = "1.13.2";

  src = fetchurl {
    url = "https://github.com/go-gitea/gitea/releases/download/v${version}/gitea-src-${version}.tar.gz";
    sha256 = "sha256-uezg8GdNqgKVHgJj9rTqHFLWuLdyDp63fzr7DMslOII=";
  };

  unpackPhase = ''
    mkdir source/
    tar xvf $src -C source/
  '';

  sourceRoot = "source";

  patches = [
    ./static-root-path.patch
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = optional pamSupport pam;

  preBuild = let
    tags = optional pamSupport "pam"
        ++ optional sqliteSupport "sqlite sqlite_unlock_notify";
    tagsString = concatStringsSep " " tags;
  in ''
    export buildFlagsArray=(
      -tags="${tagsString}"
      -ldflags='-X "main.Version=${version}" -X "main.Tags=${tagsString}"'
    )
  '';

  outputs = [ "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R ./go/src/${goPackagePath}/{public,templates,options} $data
    mkdir -p $out
    cp -R ./go/src/${goPackagePath}/options/locale $out/locale

    wrapProgram $out/bin/gitea \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  passthru.tests.gitea = nixosTests.gitea;

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ma27 ];
  };
}
