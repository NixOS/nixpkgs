{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gogs-${version}";
  version = "0.11.66";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "1b9ilk4xlsllsj5pzmxwsz4a1zvgd06a8mi9ni9hbvmfl3w8xf28";
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace pkg/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = optionalString sqliteSupport "-tags sqlite";

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
