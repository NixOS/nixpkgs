{
  fetchFromGitHub,
  fetchpatch, # Delete at next version bump.
  lib,
  libgit2,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "debase";
  # NOTE: When updating version, also update commit hash in prePatch.
  version = "3";

  src = fetchFromGitHub {
    owner = "toasterllc";
    repo = "debase";
    tag = "v${version}";
    hash = "sha256-IOh5TlFHFhIaP5bpQHYzY4wwmQUdwKePmSzEM2qx8oE=";
    fetchSubmodules = true;
  };

  prePatch = ''
    # xcrun is not available in the Darwin stdenv, but we don't need it anyway.
    substituteInPlace Makefile \
      --replace-fail 'xcrun dsymutil' dsymutil

    # NOTE: Update this when updating version.
    substituteInPlace Makefile \
      --replace-fail 'git rev-parse HEAD' 'echo aa083074d67938d50336bd3737c960b038d91134' \
      --replace-fail '$(GITHASHHEADER): .git/HEAD .git/index' '$(GITHASHHEADER):'
  '';

  patches = [
    # Ignore debase's vendored copy of libgit2 in favor of the nixpkgs version.
    ./ignore-vendored-libgit2.patch
  ];

  buildInputs = [
    libgit2
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 build-${
      if stdenv.hostPlatform.isDarwin then "mac" else "linux"
    }/release/debase $out/bin/debase
    runHook postInstall
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "ARCHS=${
      if stdenv.hostPlatform.isx86_64 then
        "x86_64"
      else if stdenv.hostPlatform.isAarch64 then
        "arm64"
      else
        throw "unsupported system: ${stdenv.system}"
    }"
  ];

  meta = {
    description = "TUI for drag-and-drop manipulation of git commits";
    homepage = "https://toaster.llc/debase";
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
