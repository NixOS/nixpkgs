{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, coreutils, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gitea-${version}";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${version}";
    sha256 = "11gzb6x8zixmkm57x8hdncmdbbvppzld3yf7p7m0abigg8zyybsj";
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = optionalString sqliteSupport "-tags sqlite";

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates} $data
    mkdir -p $out
    cp -R $src/options/locale $out/locale

    wrapProgram $bin/bin/gitea \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  meta = {
    description = "Git with a cup of tea";
    homepage = http://gitea.io;
    license = licenses.mit;
    maintainers = [ maintainers.disassembler ];
  };
}
