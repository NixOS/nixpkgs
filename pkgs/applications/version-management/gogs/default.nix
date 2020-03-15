{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  pname = "gogs";
  version = "0.11.91";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "1yfimgjg9n773kdml17119539w9736mi66bivpv5yp3cj2hj9mlj";
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace pkg/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ optional pamSupport pam;

  buildFlags = [ "-tags" ];

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
