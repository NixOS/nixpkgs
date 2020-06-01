{ stdenv, buildGoPackage, fetchurl, makeWrapper
, git, bash, gzip, openssh, pam
, fetchpatch
, sqliteSupport ? true
, pamSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  pname = "gitea";
  version = "1.11.6";

  src = fetchurl {
    url = "https://github.com/go-gitea/gitea/releases/download/v${version}/gitea-src-${version}.tar.gz";
    sha256 = "11nyq5faq0hy1pi3yhmc6y8is7jyiyfrb162fq9l33pkyw6qihqs";
  };

  unpackPhase = ''
    mkdir source/
    tar xvf $src -C source/
  '';

  sourceRoot = "source";

  patches = [
    ./static-root-path.patch
    (fetchpatch {
      url = "https://github.com/go-gitea/gitea/commit/1830d0ed5f4a67e3360ecbb55933b5540b6affce.patch";
      sha256 = "163531pcki28qfs56l64vv4xxaavxgksf038da1sn21j5l2jm81i";
    })
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = optional pamSupport pam;

  preBuild = let
    tags = optional pamSupport "pam"
        ++ optional sqliteSupport "sqlite";
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

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ma27 ];
  };
}
