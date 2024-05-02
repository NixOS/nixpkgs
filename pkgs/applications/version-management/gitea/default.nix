{ lib
, stdenv
, buildGoModule
, fetchurl
, fetchpatch
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
  version = "1.20.6";

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  src = fetchurl {
    url = "https://dl.gitea.com/gitea/${version}/gitea-src-${version}.tar.gz";
    hash = "sha256-KB7DRWAdefgLfXik+DYA6sI1XMBiSrSWoI+1YlxWalQ=";
  };

  vendorHash = null;

  patches = [
    ./static-root-path.patch
    # https://github.com/go-gitea/gitea/pull/28877
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/go-gitea/gitea/pull/28877.patch";
      hash = "sha256-cThW3EnHR695thajbnmfNziVB/iBP9OPeDgWbszYIeg=";
    })
    ./XSS-vulnerabilities-1.21.6.patch

    # Derived from https://github.com/go-gitea/gitea/pull/30136
    ./csp-early-1.21.11.patch
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
