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
  # NOTE: When updating version, also update commit hash in prePatch.
  version = "2";

  src =
    (fetchFromGitHub {
      owner = "toasterllc";
      repo = "debase";
      rev = "refs/tags/v${version}";
      hash = "sha256-6AavH8Ag+879ntcxJDbVgsg8V6U4cxwPQYPKvq2PpoQ=";
      fetchSubmodules = true;
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
    substituteInPlace Makefile \
      --replace-fail 'xcrun dsymutil' dsymutil

    # NOTE: Update this when updating version.
    substituteInPlace Makefile \
      --replace-fail 'git rev-parse HEAD' 'echo bbe9f1737ab229dd370640a4b5d5e742a051c13b' \
      --replace-fail '$(GITHASHHEADER): .git/HEAD .git/index' '$(GITHASHHEADER):'
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

  buildInputs = [
    libgit2
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Foundation ];

  installPhase = ''
    runHook preInstall
    install -Dm755 build-${if stdenv.isDarwin then "mac" else "linux"}/release/debase $out/bin/debase
    runHook postInstall
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

  meta = {
    description = "TUI for drag-and-drop manipulation of git commits";
    homepage = "https://toaster.llc/debase";
    # The author has not yet specified a license.
    # See https://github.com/toasterllc/debase/pull/4
    license = lib.licenses.publicDomain;
    mainProgram = "debase";
    maintainers = with lib.maintainers; [
      jeremyschlatter
      aleksana
    ];
    platforms = [
      # Only these systems are supported by Makefile
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
