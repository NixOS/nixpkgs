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
  pname = "forgejo";
  version = "1.18.0-rc1-1";

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  # See https://codeberg.org/forgejo/forgejo/issues/128 about URL
  src = fetchurl {
    name = "forgejo-src-${version}.tar.gz";
    url = "https://codeberg.org/attachments/976c426a-3e04-49ff-9762-47fab50624a3";
    sha256 = "sha256-kreBMHlMVB1UeG67zMbszGrgjaROateCRswH7GrKnEw=";
  };


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

  passthru.tests = nixosTests.gitea;

  meta = with lib; {
    description = "Beyond coding. We forge.";
    homepage = "https://forgejo.org";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
  };
}
