{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gogs-${version}";
  version = "0.11.86";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "0l8mwy0cyy3cdxqinf8ydb35kf7c8pj09xrhpr7rr7lldnvczabw";
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace pkg/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ optional pamSupport pam;

  buildFlags = "-tags";

  buildFlagsArray =
    (  optional sqliteSupport "sqlite"
    ++ optional pamSupport "pam");

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates} $data

    wrapProgram $bin/bin/gogs \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "github.com/gogs/gogs";

  meta = {
    description = "A painless self-hosted Git service";
    homepage = https://gogs.io;
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
  };
}
