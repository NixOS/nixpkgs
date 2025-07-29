{
  lib,
  buildGoModule,
  buildFHSEnv,
  binutils,
  dejavu_fonts,
  pkg-config,
  fetchFromGitHub,
  roboto,
  xorg,
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

  libs = with xorg; [
    libX11.dev
    libXcursor.dev
    libXext.dev
    libXi.dev
    libXinerama.dev
    libXrandr.dev
    libXrender.dev
    libXfixes.dev
    libXxf86vm
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
