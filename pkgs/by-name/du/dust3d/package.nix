{
  versionType ? "stable",

  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  unstableGitUpdater,

  qt6,
  pipewire,
}:

let
  versionInfo =
    {
      stable = rec {
        version = "1.1.6";
        rev = version;
        hash = "sha256-iDkEP/MXUaMwGntSalXgBpJZTrQn7lqzX0GnoTZzTc4=";
        updateScript = gitUpdater;

        patches = [
          # Adds missing imports of <cstdint> and std:: namespacing
          # PR merged in master (https://github.com/huxingyi/dust3d/pull/191)
          (fetchpatch2 {
            url = "https://github.com/huxingyi/dust3d/commit/2f5fbe61f39c0914a81431df5ee8b08e8e9fa667.diff?full_index=1";
            hash = "sha256-7eNUVlEiF7AFOGl7TMSDDiHciu8r8fkLN6MQQieLrIg=";
          })

          # Fixes memory leak with localized punctuation of numbers
          # PR merged in master (https://github.com/huxingyi/dust3d/pull/197)
          (fetchpatch2 {
            url = "https://github.com/huxingyi/dust3d/commit/4487099406aae836d4800b57ed3292111ae751e2.diff?full_index=1";
            hash = "sha256-85lWZAAFDMQcsrI/iPDJMCVrXBugqMcGu8mvKLo0zus=";
          })

          # Adds missing import of <cstdint>
          # PR merged in master (https://github.com/huxingyi/dust3d/pull/199)
          (fetchpatch2 {
            url = "https://github.com/huxingyi/dust3d/commit/26acb0a77a0ee6938076ccb68487d2adc0e40d46.diff?full_index=1";
            hash = "sha256-P1EsC6w6nhfr7rgDLcoq/4f70Qjm+KqMzQlWC7Vjcd0=";
          })
        ];
      };

      unstable = {
        version = "1.1.6-unstable-2026-09-27";
        rev = "bde0ef02c5bd204758e06535cd6b4ba5b69f4eba";
        hash = "sha256-DYJpBB8dS2gt4eLhfgggWqALAEszmWRpDGfHoAf0iho=";
        updateScript = unstableGitUpdater;

        patches = [ ];
      };
    }
    .${versionType};

in

stdenv.mkDerivation {
  pname = "dust3d";
  inherit (versionInfo) version patches;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    inherit (versionInfo) rev hash;

    owner = "huxingyi";
    repo = "dust3d";
  };

  postPatch = lib.optionalString (versionType == "unstable") ''
    substituteInPlace application/application.pro \
      --replace-fail "HUMAN_VERSION = " "HUMAN_VERSION = \"${versionInfo.version}\" #" \
      --replace-fail "VERSION = " "VERSION = ${versionInfo.version} #"
  '';

  nativeBuildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtmultimedia
  ];

  configurePhase = ''
    runHook preConfigure

    cd application
    qmake

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dust3d

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    qtWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pipewire ]}")
  '';

  passthru.updateScript = versionInfo.updateScript;

  meta = {
    changelog = "https://github.com/huxingyi/dust3d/blob/${versionInfo.rev}/CHANGELOGS";
    description = "Cross-platform 3D modeling software";
    longDescription = ''
      Dust3D is a cross-platform 3D modeling software that makes it easy to create low poly 3D models for video games, 3D printing, and more.
    '';
    homepage = "https://dust3d.org/";
    license = lib.licenses.mit;
    mainProgram = "dust3d";
    maintainers = with lib.maintainers; [
      fehnomenal
    ];
  };
}
