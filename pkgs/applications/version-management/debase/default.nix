{
  darwin,
  fetchFromGitHub,
  fetchpatch, # Delete at next version bump.
  lib,
  libgit2,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "debase";
  version = "2";

  src =
    (fetchFromGitHub {
      owner = "toasterllc";
      repo = "debase";
      rev = "refs/tags/v${version}";
      hash = "sha256-FIWGJtjmLpvxHxDbmbL55FKNkRaBvcPsdWimGWdPfmU=";
      fetchSubmodules = true;
      leaveDotGit = true;
    }).overrideAttrs
      {
        # Workaround to fetch git@github.com submodules.
        # See https://github.com/NixOS/nixpkgs/issues/195117
        #
        # Already fixed in latest upstream, so delete at next version bump.
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      };

  prePatch = ''
    # xcrun is not available in the Darwin stdenv, but we don't need it anyway.
    substituteInPlace Makefile --replace-warn 'xcrun dsymutil' dsymutil

    # Avoid a build-time dependency on git, since this works just as well.
    substituteInPlace Makefile --replace-warn 'git rev-parse HEAD' 'cat .git/shallow'
  '';

  patches = [
    # Ignore debase's vendored copy of libgit2 in favor of the nixpkgs version.
    ./ignore-vendored-libgit2.patch
    # Already fixed in latest upstream, so delete at next version bump.
    (fetchpatch {
      url = "https://github.com/toasterllc/debase/commit/d483c5ac016ac2ef3600e93ae4022cd9d7781c83.patch";
      hash = "sha256-vVQMOEiLTd46+UknZm8Y197sjyK/kTK/M+9sRX9AssY=";
    })
  ];

  # The Makefile depends on .git/index existing. An empty file suffices.
  preBuild = "touch .git/index";

  buildInputs = [
    libgit2
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk_11_0.frameworks.Foundation;

  installPhase = ''
    mkdir -p $out/bin
    cp build-${if stdenv.isDarwin then "mac" else "linux"}/release/debase $out/bin
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "ARCHS=${
      if stdenv.isx86_64 then
        "x86_64"
      else if stdenv.isAarch64 then
        "arm64"
      else
        abort "unsupported system: ${stdenv.system}"
    }"
  ];

  meta = with lib; {
    description = "TUI for drag-and-drop manipulation of git commits";
    homepage = "https://toaster.llc/debase";
    # The author has not yet specified a license.
    # See https://github.com/toasterllc/debase/pull/4
    license = licenses.unfree;
    mainProgram = "debase";
    maintainers = with maintainers; [ jeremyschlatter ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
