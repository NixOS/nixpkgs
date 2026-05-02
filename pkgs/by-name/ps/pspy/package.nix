{
  buildGoModule,
  fetchFromGitHub,
  lib,
  upx,
  versionCheckHook,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
  arch =
    {
      aarch64-linux = {
        _32 = "arm";
        _64 = "arm64";
      };

      x86_64-linux = {
        _32 = "386";
        _64 = "amd64";
      };
    }
    .${system} or (throw "Unsupported system ${system}!");
in
buildGoModule (finalAttrs: {
  pname = "pspy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "DominicBreuker";
    repo = "pspy";
    tag = "v${finalAttrs.version}";

    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      rm -rf $out/.git
    '';

    hash = "sha256-CPWoKxmjlGYP2kAC+LscOtrPpUjzpRoGTeohlw0mmh4=";
  };

  vendorHash = "sha256-mgAsy2ufMDNpeCXG/cZ10zdmzFoGfcpCzPWIABnvJWU=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ upx ];

  # we build both 32 and 64 bit binaries just like upstream does
  # however our "small" versions are not dynamically linked, only compressed
  # since dynamically linked binaries would refer to missing Nix store paths
  # when they are copied onto a target system
  buildPhase = ''
    runHook preBuild

    ldflags+=" -X main.commit=$(<.git_head)"

    GOARCH=${arch._32} go build -ldflags "$ldflags" -o bin/pspy32
    GOARCH=${arch._64} go build -ldflags "$ldflags" -o bin/pspy64

    upx bin/pspy32 -o bin/pspy32s
    upx bin/pspy64 -o bin/pspy64s

    runHook postBuild
  '';

  # the various TestStart* tests defined in $src/internal/pspy/pspy_test.go
  # can in rare cases hit a race condition
  # ("Did not get message in time" or "Wrong message")
  checkPhase = ''
    runHook preCheck

    go test -skip='^TestStart' ./...

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv bin $out

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  meta = {
    description = "Monitor linux processes without root permissions";
    homepage = "https://github.com/DominicBreuker/pspy";
    license = lib.licenses.gpl3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.eleonora ];
    mainProgram = "pspy64";
  };
})
