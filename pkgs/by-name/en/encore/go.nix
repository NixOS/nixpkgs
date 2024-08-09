{ fetchFromGitHub, stdenv, lib, go, ... }:
stdenv.mkDerivation (finalAttrs: {
  pname = "go-encore";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "encoredev";
    repo = "go";
    rev = "encore-go${finalAttrs.version}";
    hash = "sha256-SSa3CoUS6JMfs6T1PMb3NK8UeJnpLlTIn46/3oCTnL8=";
  };

  buildInputs = [ go ];

  patchPhase = let
    goSrc = fetchFromGitHub {
      owner = "golang";
      repo = "go";
      rev = "release-branch.go${lib.versions.majorMinor finalAttrs.version}";
      hash = "sha256-amASGhvBcW90dylwFRC2Uj4kOAOKCgWmFKhLnA9dOgg=";
    };
  in ''
    runHook prePatch

    # delete submodule and replace with the go source
    rm -rf go
    cp -r ${goSrc} go
    chmod -R u+rw go

    pushd go

    for patch in ../patches/*.diff; do
      patch --verbose -p1 --ignore-whitespace < "$patch"
    done

    cp -p -P -v -R ../overlay/* ./

    popd

    runHook postPatch
  '';

  installPhase = let
    goarch = platform:
      {
        "aarch64" = "arm64";
        "arm" = "arm";
        "armv5tel" = "arm";
        "armv6l" = "arm";
        "armv7l" = "arm";
        "i686" = "386";
        "mips" = "mips";
        "mips64el" = "mips64le";
        "mipsel" = "mipsle";
        "powerpc64" = "ppc64";
        "powerpc64le" = "ppc64le";
        "riscv64" = "riscv64";
        "s390x" = "s390x";
        "x86_64" = "amd64";
      }.${platform.parsed.cpu.name} or (throw
        "Unsupported system: ${platform.parsed.cpu.name}");
  in ''
    runHook preInstall

    mkdir -p $TMPDIR/.gobuild-cache $out/{bin,share/go}
    GOCACHE=$TMPDIR/.gobuild-cache go run . \
      --goos "${stdenv.targetPlatform.parsed.kernel.name}" \
      --goarch "${goarch stdenv.targetPlatform}"

    cp -r dist/${stdenv.targetPlatform.parsed.kernel.name}_${
      goarch stdenv.targetPlatform
    }/encore-go/* $out/share/go
    ln -s $out/share/go/bin/go $out/bin/go-encore

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Rolling fork of Go with added automatic tracing and instrumentation for use with the encore package";
    homepage = "https://encore.dev";
    maintainers = with maintainers; [ luisnquin ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "go-encore";
  };
})
