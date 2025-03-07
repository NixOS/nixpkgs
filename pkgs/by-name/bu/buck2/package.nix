{
  fetchurl,
  lib,
  stdenv,
  zstd,
  installShellFiles,
  testers,
  buck2, # for passthru.tests
}:

# NOTE (aseipp): buck2 uses a precompiled binary build for good reason — the
# upstream codebase extensively uses unstable `rustc` nightly features, and as a
# result can't be built upstream in any sane manner. it is only ever tested and
# integrated against a single version of the compiler, which produces all usable
# binaries. you shouldn't try to workaround this or get clever and think you can
# patch it to work; just accept it for now. it is extremely unlikely buck2 will
# build with a stable compiler anytime soon; see related upstream issues:
#
#   - NixOS/nixpkgs#226677
#   - NixOS/nixpkgs#232471
#   - facebook/buck2#265
#   - facebook/buck2#322
#
# worth noting: it *is* possible to build buck2 from source using
# buildRustPackage, and it works fine, but only if you are using flakes and can
# import `rust-overlay` from somewhere else to vendor your compiler. See
# nixos/nixpkgs#226677 for more information about that.

# NOTE (aseipp): this expression is mostly automated, and you are STRONGLY
# RECOMMENDED to use to nix-update for updating this expression when new
# releases come out, which runs the sibling `update.sh` script.
#
# from the root of the nixpkgs git repository, run:
#
#    nix-shell maintainers/scripts/update.nix \
#      --argstr commit true \
#      --argstr package buck2

let

  # build hashes, which correspond to the hashes of the precompiled binaries
  # procued by GitHub Actions. this also includes the hash for a download of a
  # compatible buck2-prelude
  buildHashes = builtins.fromJSON (builtins.readFile ./hashes.json);

  # our version of buck2; this should be a git tag
  version = "2025-01-02";

  # map our platform name to the rust toolchain suffix
  # NOTE (aseipp): must be synchronized with update.sh!
  platform-suffix =
    {
      x86_64-darwin = "x86_64-apple-darwin";
      aarch64-darwin = "aarch64-apple-darwin";
      x86_64-linux = "x86_64-unknown-linux-musl";
      aarch64-linux = "aarch64-unknown-linux-musl";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # the platform-specific, statically linked binary — which is also
  # zstd-compressed
  buck2-src =
    let
      name = "buck2-${version}-${platform-suffix}.zst";
      hash = buildHashes."buck2-${stdenv.hostPlatform.system}";
      url = "https://github.com/facebook/buck2/releases/download/${version}/buck2-${platform-suffix}.zst";
    in
    fetchurl { inherit name url hash; };

  # rust-project, which is used to provide IDE integration Buck2 Rust projects,
  # is part of the official distribution
  rust-project-src =
    let
      name = "rust-project-${version}-${platform-suffix}.zst";
      hash = buildHashes."rust-project-${stdenv.hostPlatform.system}";
      url = "https://github.com/facebook/buck2/releases/download/${version}/rust-project-${platform-suffix}.zst";
    in
    fetchurl { inherit name url hash; };

  # compatible version of buck2 prelude; this is exported via passthru.prelude
  # for downstream consumers to use when they need to automate any kind of
  # tooling
  prelude-src =
    let
      prelude-hash = "d11a72de049a37b9b218a3ab8db33d3f97b9413c";
      name = "buck2-prelude-${version}.tar.gz";
      hash = buildHashes."_prelude";
      url = "https://github.com/facebook/buck2-prelude/archive/${prelude-hash}.tar.gz";
    in
    fetchurl { inherit name url hash; };

in
stdenv.mkDerivation {
  pname = "buck2";
  version = "unstable-${version}"; # TODO (aseipp): kill 'unstable' once a non-prerelease is made
  srcs = [
    buck2-src
    rust-project-src
  ];
  sourceRoot = ".";

  nativeBuildInputs = [
    installShellFiles
    zstd
  ];

  doCheck = true;
  dontConfigure = true;
  dontStrip = true;

  unpackPhase = "unzstd ${buck2-src} -o ./buck2 && unzstd ${rust-project-src} -o ./rust-project";
  buildPhase = "chmod +x ./buck2 && chmod +x ./rust-project";
  checkPhase = "./buck2 --version && ./rust-project --version";
  installPhase = ''
    mkdir -p $out/bin
    install -D buck2 $out/bin/buck2
    install -D rust-project $out/bin/rust-project
  '';
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd buck2 \
      --bash <( $out/bin/buck2 completion bash ) \
      --fish <( $out/bin/buck2 completion fish ) \
      --zsh <( $out/bin/buck2 completion zsh )
  '';

  passthru = {
    prelude = prelude-src;

    updateScript = ./update.sh;
    tests = testers.testVersion {
      package = buck2;

      # NOTE (aseipp): the buck2 --version command doesn't actually print out
      # the given version tagged in the release, but a hash, but not the git
      # hash; the entire version logic is bizarrely specific to buck2, and needs
      # to be reworked the open source build to behave like expected. in the
      # mean time, it *does* always print out 'buck2 <hash>...' so we can just
      # match on "buck2"
      version = "buck2";
    };
  };

  meta = with lib; {
    description = "Fast, hermetic, multi-language build system";
    homepage = "https://buck2.build";
    changelog = "https://github.com/facebook/buck2/releases/tag/${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "buck2";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
