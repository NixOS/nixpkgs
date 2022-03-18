{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
, writeShellScriptBin
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "sha256-m47Y4IXGc43XLs5d6ehlD0A53BWC5kO3K2BS/xbYgl8=";

    # see the comment below on fakeGit for how this is used
    leaveDotGit = true;
    postFetch = ''
      ( cd $out; git rev-parse --short HEAD > .git_commit )
      rm -rf $out/.git
    '';
  };

  cargoSha256 = "sha256-JBacioy2woAfKQuK6tXU9as4DNc+3uY3F3GWksCf6WU=";

  nativeBuildInputs =
    let
      # the build process of polkadot requires a .git folder in order to determine
      # the git commit hash that is being built and add it to the version string.
      # since having a .git folder introduces reproducibility issues to the nix
      # build, we check the git commit hash after fetching the source and save it
      # into a .git_commit file, and then delete the .git folder. then we create a
      # fake git command that will just return the contents of this file, which will
      # be used when the polkadot build calls `git rev-parse` to fetch the commit
      # hash.
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "rev-parse --short HEAD" ]]; then
          cat /build/source/.git_commit
        else
          >&2 echo "Unknown command: $@"
          exit 1
        fi
      '';
    in
    [ clang fakeGit ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.linux;
  };
}
