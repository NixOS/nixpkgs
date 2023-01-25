{ lib
, stdenv
, buildGoModule
, fetchurl
, makeWrapper
, git
, bash
, openssh
, gzip
, pam
, pamSupport ? true
, sqliteSupport ? true
}:

buildGoModule rec {
  pname = "forgejo";
  version = "1.18.2-1";

  src = fetchurl {
    name = "${pname}-src-${version}.tar.gz";
    # see https://codeberg.org/forgejo/forgejo/releases
    url = "https://codeberg.org/attachments/44ff6fcb-1515-4bba-85bf-3d3795ced2f7";
    hash = "sha256-XSh17AwPtC+Y24lgjjXJzT/uBHg+0hWZ2RZ/eNF4mCY=";
  };

  vendorHash = null;

  subPackages = [ "." ];

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
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  postInstall = ''
    mkdir $data
    cp -R ./{public,templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  meta = with lib; {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    broken = stdenv.isDarwin;
  };
}
