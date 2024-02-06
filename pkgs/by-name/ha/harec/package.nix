{ lib
, stdenv
, fetchFromSourcehut
, qbe
, fetchgit
, unstableGitUpdater
}:
let
  # harec needs the dbgfile and dbgloc features implemented up to this commit.
  # This can be dropped once 1.2 is released. For a possible release date, see:
  # https://lists.sr.ht/~mpu/qbe/%3CZPkmHE9KLohoEohE%40cloudsdale.the-delta.net.eu.org%3E
  qbe' = qbe.overrideAttrs (_old: {
    version = "1.1-unstable-2024-01-12";
    src = fetchgit {
      url = "git://c9x.me/qbe.git";
      rev = "85287081c4a25785dec1ec48c488a5879b3c37ac";
      hash = "sha256-7bVbxUU/HXJXLtAxhoK0URmPtjGwMSZrPkx8WKl52Mg=";
    };
  });

  platform = lib.toLower stdenv.hostPlatform.uname.system;
  arch = stdenv.hostPlatform.uname.processor;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
  version = "0-unstable-2024-01-29";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = "f9e17e633845d8d38566b4ea32db0a29ac85d96e";
    hash = "sha256-Xy9VOcDtbJUz3z6Vk8bqH41VbAFKtJ9fzPGEwVz8KQM=";
  };

  nativeBuildInputs = [
    qbe'
  ];

  buildInputs = [
    qbe'
  ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "ARCH=${arch}"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;

  postConfigure = ''
    ln -s configs/${platform}.mk config.mk
  '';

  passthru = {
    # We create this attribute so that the `hare` package can access the
    # overwritten `qbe`.
    qbeUnstable = qbe';
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "harec";
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    # UPDATE: https://github.com/hshq/harelang provides a MacOS port
    platforms = with lib.platforms;
      lib.intersectLists (freebsd ++ openbsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = lib.platforms.darwin;
  };
})
