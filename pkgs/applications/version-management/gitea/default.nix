{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  pname = "gitea";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${version}";
    sha256 = "04jg1b0d1fbhnk434dnffc2c118gs084za3m33lxwf5lxzlbbimc";
    # Required to generate the same checksum on MacOS due to unicode encoding differences
    # More information: https://github.com/NixOS/nixpkgs/pull/48128
    extraPostFetch = ''
      rm -rf $out/integrations
      rm -rf $out/vendor/github.com/Unknown/cae/tz/testdata
      rm -rf $out/vendor/github.com/Unknown/cae/zip/testdata
      rm -rf $out/vendor/gopkg.in/macaron.v1/fixtures
    '';
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ optional pamSupport pam;

  preBuild = let
    tags = optional pamSupport "pam"
        ++ optional sqliteSupport "sqlite";
    tagsString = concatStringsSep " " tags;
  in ''
    export buildFlagsArray=(
      -tags="${tagsString}"
      -ldflags='-X "main.Version=${version}" -X "main.Tags=${tagsString}"'
    )
  '';

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates,options} $data
    mkdir -p $out
    cp -R $src/options/locale $out/locale

    wrapProgram $bin/bin/gitea \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ];
  };
}
