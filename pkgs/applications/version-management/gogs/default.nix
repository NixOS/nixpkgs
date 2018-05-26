{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, coreutils, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gogs-${version}";
  version = "0.11.34";

  src = fetchFromGitHub {
    owner = "gogits";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "15xwcw3k7wbahdgp796gly79qkka21p7kvm84zfjgcsjjri0kdnz";
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

  goPackagePath = "github.com/gogits/gogs";

  meta = {
    description = "A painless self-hosted Git service";
    homepage = https://gogs.io;
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
  };
}
