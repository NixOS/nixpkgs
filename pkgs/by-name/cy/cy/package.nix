{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  libx11,
  ncurses,
  vim,
  testers,
  makeBinaryWrapper,
}:
buildGoModule (finalAttrs: {
  pname = "cy";
  version = "1.12.0";
  src = fetchFromGitHub {
    owner = "cfoust";
    repo = "cy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QWPaFLzySiju17u5YEIFjAaNbDEXI+e0yZ91pdaPC+4=";
  };
  vendorHash = null;

  subPackages = [ "cmd/cy" ];

  patches = [ ./disable-deadlock-lock-order.patch ];

  postPatch = ''
    substituteInPlace \
      pkg/cy/cy_test.go \
      pkg/cy/testing.go \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    libx11
  ];

  ldflags =
    let
      versionPkg = "github.com/cfoust/cy/pkg/version";
    in
    [
      "-X ${versionPkg}.Version=v${finalAttrs.version}"
      "-X ${versionPkg}.GoVersion=${finalAttrs.finalPackage.go.version}"
      "-X ${versionPkg}.GitCommit=${finalAttrs.src.rev}"
    ];

  postFixup = ''
    wrapProgram $out/bin/cy \
      --suffix TERMINFO_DIRS : ${ncurses}/share/terminfo \
      --suffix LD_LIBRARY_PATH : ${libx11}/lib
  '';

  nativeCheckInputs = [
    bash
    vim
  ];

  preCheck = ''
    export HOME="$TMPDIR"
    mkdir -p "$HOME"

    export TERMINFO_DIRS="${ncurses}/share/terminfo"
    export EDITOR="${vim}/bin/vim"
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "cy --version";
      version = "v${finalAttrs.version}";
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "A time travelling terminal multiplexer";
    homepage = "https://cfoust.github.io/cy/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wilsonsk0 ];
    platforms = lib.platforms.linux;
    mainProgram = "cy";
  };
})
