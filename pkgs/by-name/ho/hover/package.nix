{
  lib,
  buildGoModule,
  buildFHSEnv,
  binutils,
  dejavu_fonts,
  pkg-config,
  fetchFromGitHub,
  roboto,
  libxxf86vm,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxfixes,
  libxext,
  libxcursor,
  libx11,
  xorgproto,
  libglvnd,
  addDriverRunpath,
  makeWrapper,
  gcc,
  go,
  flutter,
}:

let
  pname = "hover";
  version = "0.47.2";

  libs = [
    libx11.dev
    libxcursor.dev
    libxext.dev
    libxi.dev
    libxinerama.dev
    libxrandr.dev
    libxrender.dev
    libxfixes.dev
    libxxf86vm
    libglvnd.dev
    xorgproto
  ];
  hover = buildGoModule {
    inherit pname version;

    meta = {
      description = "Build tool to run Flutter applications on desktop";
      homepage = "https://github.com/go-flutter-desktop/hover";
      license = [ lib.licenses.bsd3 ];
      platforms = lib.platforms.linux;
      maintainers = [ lib.maintainers.ericdallo ];
    };

    subPackages = [ "." ];

    vendorHash = "sha256-LDVF1vt1kTm7G/zqWHcjtGK+BsydgmJUET61+sILiE0=";

    src = fetchFromGitHub {
      tag = "v${version}";
      owner = "go-flutter-desktop";
      repo = "hover";
      sha256 = "sha256-xS4qfsGZAt560dxHpwEnAWdJCd5vuTdX+7fpUGrSqhw=";
    };

    nativeBuildInputs = [
      addDriverRunpath
      makeWrapper
    ];

    buildInputs = libs;

    checkRun = false;

    postInstall = ''
      wrapProgram "$out/bin/hover" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath libs}
    '';

    postFixup = ''
      addDriverRunpath $out/bin/hover
    '';
  };

in
buildFHSEnv {
  inherit pname version;
  targetPkgs =
    pkgs:
    [
      binutils
      dejavu_fonts
      flutter
      gcc
      go
      hover
      pkg-config
      roboto
    ]
    ++ libs;

  runScript = "hover";
}
