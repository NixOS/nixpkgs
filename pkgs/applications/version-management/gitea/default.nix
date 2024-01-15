{ lib
, stdenv
, buildGoModule
, fetchurl
, makeWrapper
, git
, bash
, coreutils
, gitea
, gzip
, openssh
, pam
, sqliteSupport ? true
, pamSupport ? true
, runCommand
, brotli
, xorg
, nixosTests
}:

buildGoModule rec {
  pname = "gitea";
  version = "1.21.3";

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  src = fetchurl {
    url = "https://dl.gitea.com/gitea/${version}/gitea-src-${version}.tar.gz";
    hash = "sha256-tJC9p7++lb3lD0yYR4qAtFOTRBQK2SkNCD6Tk+g9M78=";
  };

  vendorHash = null;

  patches = [
    ./static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
  '';

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optional pamSupport pam;

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  outputs = [ "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R ./{public,templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale

    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash coreutils git gzip openssh ]}
  '';

  passthru = {
    data-compressed = runCommand "gitea-data-compressed" {
      nativeBuildInputs = [ brotli xorg.lndir ];
    } ''
      mkdir $out
      lndir ${gitea.data}/ $out/

      # Create static gzip and brotli files
      find -L $out -type f -regextype posix-extended -iregex '.*\.(css|html|js|svg|ttf|txt)' \
        -exec gzip --best --keep --force {} ';' \
        -exec brotli --best --keep --no-copy-stat {} ';'
    '';

    tests = nixosTests.gitea;
  };

  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ma27 techknowlogick ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
