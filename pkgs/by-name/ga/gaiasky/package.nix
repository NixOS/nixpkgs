{
  lib,
  stdenv,
  fetchFromGitea,
  writeShellScriptBin,
  replaceVars,

  gradle,
  help2man,

  jdk25,
  libGL,
}:

let
  # -XX:+UseCompactObjectHeaders is being used in the launcher script,
  # but it is only supported Java 25+
  jre = jdk25;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gaiasky";
  version = "3.7.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gaiasky";
    repo = "gaiasky";
    tag = finalAttrs.version;
    hash = "sha256-UAVuivkeF234hoUyfCv7depspr3dyoyzYJDD0mKGAr4=";
  };

  patches = [
    (replaceVars ./launcher.patch {
      java_exe_path = lib.getExe jre;
      library_path = lib.makeLibraryPath (
        lib.optionals stdenv.hostPlatform.isLinux [
          libGL
        ]
      );
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --abbrev=0 --tags HEAD" ]]; then
          echo "${finalAttrs.version}"
        elif [[ $@ = "rev-parse --short HEAD" ]]; then
          echo "nixpkgs"
        else
          >&2 echo "Unknown command: $@"
          exit 1
        fi
      '';
    in
    [
      fakeGit
      gradle
      help2man
    ];

  preBuild = ''
    # help2man is executed during the build, which executes this binary
    patchShebangs core/exe/gaiasky
  '';

  gradleBuildTask = "core:dist";

  installFlags = [
    "PREFIX=$(out)"
    "APPPREFIX=$(out)/share"
  ];

  postInstall = ''
    substituteInPlace $out/share/gaiasky/gaiasky.desktop \
      --replace-fail 'Icon=/opt/gaiasky/gs_icon.svg' 'Icon=gaiasky'

    install -Dm644 "$out/share/gaiasky/gaiasky.desktop" "$out/share/applications/gaiasky.desktop"
    install -Dm644 "$out/share/gaiasky/gs_icon.svg" "$out/share/icons/hicolor/scalable/apps/gaiasky.svg"
  '';

  meta = {
    description = "Open source 3D universe visualization software for desktop and VR with support for more than a billion objects";
    homepage = "https://codeberg.org/gaiasky/gaiasky";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gaiasky";
    platforms = lib.platforms.all;
  };
})
