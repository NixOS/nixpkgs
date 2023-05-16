<<<<<<< HEAD
{ lib
, fetchFromGitLab
, fetchFromGitHub
, buildGoModule
, pkg-config

# libgit2 + dependencies
, libgit2
, http-parser
, openssl
, pcre
, zlib
}:

let
  version = "16.3.3";
=======
{ lib, fetchFromGitLab, fetchFromGitHub, buildGoModule, ruby
, bundlerEnv, pkg-config
# libgit2 + dependencies
, libgit2, openssl, zlib, pcre, http-parser }:

let
  rubyEnv = bundlerEnv rec {
    name = "gitaly-env";
    inherit ruby;
    copyGemFiles = true;
    gemdir = ./.;
  };

  version = "15.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  commonOpts = {
    inherit version;

    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
<<<<<<< HEAD
      hash = "sha256-V9uh5QkvQ1ifO5DNCivg47NBjgE06Ehz7DnmBeU3lVY=";
    };

    vendorHash = "sha256-abyouKgn31yO3+oeowtxZcuvS6mazVM8zOMEFsyw4C0=";
=======
      sha256 = "sha256-3bbk9LDqo6hm8eG17+a7udM/yHjvXi3f32gNwXhrMrI=";
    };

    vendorSha256 = "sha256-gJelagGPogeCdJtRpj4RaYlqzZRhtU0EIhmj1aK4ZOk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    ldflags = [ "-X ${gitaly_package}/internal/version.version=${version}" "-X ${gitaly_package}/internal/version.moduleVersion=${version}" ];

    tags = [ "static,system_libgit2" ];

    nativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
    buildInputs = [ libgit2 openssl zlib pcre http-parser ];
=======
    buildInputs = [ rubyEnv.wrappedRuby libgit2 openssl zlib pcre http-parser ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    doCheck = false;
  };

  auxBins = buildGoModule ({
    pname = "gitaly-aux";

<<<<<<< HEAD
    subPackages = [ "cmd/gitaly-hooks" "cmd/gitaly-ssh" "cmd/gitaly-git2go" "cmd/gitaly-lfs-smudge" "cmd/gitaly-gpg" ];
=======
    subPackages = [ "cmd/gitaly-hooks" "cmd/gitaly-ssh" "cmd/gitaly-git2go" "cmd/gitaly-lfs-smudge" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  } // commonOpts);
in
buildGoModule ({
  pname = "gitaly";

<<<<<<< HEAD
=======
  passthru = {
    inherit rubyEnv;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  subPackages = [ "cmd/gitaly" "cmd/gitaly-backup" ];

  preConfigure = ''
    mkdir -p _build/bin
    cp -r ${auxBins}/bin/* _build/bin
  '';

<<<<<<< HEAD
  outputs = [ "out" ];
=======
  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib} $ruby
  '';

  outputs = [ "out" "ruby" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://gitlab.com/gitlab-org/gitaly";
    description = "A Git RPC service for handling all the git calls made by GitLab";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
<<<<<<< HEAD
    maintainers = teams.gitlab.members;
=======
    maintainers = with maintainers; [ roblabla globin talyz yayayayaka ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };
} // commonOpts)
