{
  lib,
  stdenv,
  fetchFromGitea,
  writeShellScriptBin,
  replaceVars,

  gradle,
  help2man,

  jre,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gaiasky";
  version = "3.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gaiasky";
    repo = "gaiasky";
    tag = finalAttrs.version;
    hash = "sha256-yajLFYgi43hRXNxmtfNvJQlavxtjirrwPMDEnhMzsVg=";
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
