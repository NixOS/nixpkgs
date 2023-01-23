{ lib
, stdenv
, buildGoPackage
, fetchurl
, makeWrapper
, git
, bash
, gzip
, openssh
, pam
, pamSupport ? true
, sqliteSupport ? true
}:

buildGoPackage rec {
  pname = "forgejo";
  version = "1.18.2-0";

  src = fetchurl {
    name = "${pname}-src-${version}.tar.gz";
    # see https://codeberg.org/forgejo/forgejo/releases
    url = "https://codeberg.org/attachments/5d59ec04-9f29-4b32-a1ef-bec5c3132e26";
    hash = "sha256-RLShwdx8geyFr1Jk5qDVbsEt2hCjdrwX0lNHea7P+pk=";
  };

  outputs = [ "out" "data" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./../gitea/static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];
  ldflags = [
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  postInstall = ''
    mkdir $data
    cp -R ./go/src/${goPackagePath}/{public,templates,options} $data
    mkdir -p $out
    cp -R ./go/src/${goPackagePath}/options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  meta = with lib; {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    broken = stdenv.isDarwin;
  };
}
