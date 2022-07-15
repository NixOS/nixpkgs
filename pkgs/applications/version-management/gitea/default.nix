{ lib
, buildGoPackage
, fetchurl
, makeWrapper
, git
, bash
, gzip
, openssh
, pam
, sqliteSupport ? true
, pamSupport ? true
, nixosTests
}:

buildGoPackage rec {
  pname = "gitea";
  version = "1.16.9";

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  src = fetchurl {
    url = "https://github.com/go-gitea/gitea/releases/download/v${version}/gitea-src-${version}.tar.gz";
    sha256 = "sha256-LxPYUSyRSfDlGwCC2IFPEISP4wsRJsUbwi9F7sxbMOE=";
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
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optional pamSupport pam;

  preBuild =
    let
      tags = lib.optional pamSupport "pam"
        ++ lib.optional sqliteSupport "sqlite sqlite_unlock_notify";
      tagsString = lib.concatStringsSep " " tags;
    in
    ''
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
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  passthru.tests.gitea = nixosTests.gitea;

  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ma27 techknowlogick ];
  };
}
