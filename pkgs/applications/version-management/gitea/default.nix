{ lib
, stdenv
, buildGoModule
, fetchurl
, makeWrapper
, git
, bash
<<<<<<< HEAD
, coreutils
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.20.4";
=======
  version = "1.19.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # not fetching directly from the git repo, because that lacks several vendor files for the web UI
  src = fetchurl {
    url = "https://dl.gitea.com/gitea/${version}/gitea-src-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-96LI7/4FZy17KED2xc4UFyW4e47DZMuSnMw7loYYB8c=";
=======
    hash = "sha256-rSvBeSnJ356Yba7tZXg0S11ZRzYmF3xnOl4ZUJ8XQYw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  patches = [
    ./static-root-path.patch
  ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace modules/setting/server.go --subst-var data
=======
    substituteInPlace modules/setting/setting.go --subst-var data
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      --prefix PATH : ${lib.makeBinPath [ bash coreutils git gzip openssh ]}
=======
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "gitea";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
