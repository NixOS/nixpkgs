{ lib
, stdenv
, buildGoModule
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

buildGoModule rec {
  pname = "gitea";
  version = "1.18.3";

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  src = fetchurl {
    url = "https://dl.gitea.io/gitea/${version}/gitea-src-${version}.tar.gz";
    hash = "sha256-jqjpbDgcmwZoc/ovgburFeeta9mAJOmz7yrvmUKAwRU=";
  };

  vendorHash = null;

  patches = [
    ./static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  subPackages = [ "." ];

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

  ldflags = [ "-s" "-w" ];

  outputs = [ "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R ./{public,templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale

    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  passthru.tests = nixosTests.gitea;

  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ma27 techknowlogick ];
    broken = stdenv.isDarwin;
  };
}
