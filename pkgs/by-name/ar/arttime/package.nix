{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  patchRcPathBash,
  makeWrapper,
  zsh,
  coreutils,
  gnused,
  tzdata,
  diffutils,
  less,

  # Optional dependencies
  withLibnotify ? true,
  withVorbistools ? true,
  withFzf ? true,

  libnotify,
  vorbis-tools,
  fzf,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arttime";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "poetaman";
    repo = "arttime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-luz2tz8ammN4Xiw5q4vUVAAwIpbDNU/vO/ewTlvjRHA=";
  };

  nativeBuildInputs = [
    installShellFiles
    patchRcPathBash
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a bin $out
    cp -a share/arttime $out/share

    runHook postInstall
  '';

  postInstall =
    let
      runtimeDependencies = [
        gnused
        diffutils
        less
      ]
      ++ lib.optionals withLibnotify [ libnotify ]
      ++ lib.optionals withVorbistools [ vorbis-tools ]
      ++ lib.optionals withFzf [ fzf ];
    in
    ''
      installManPage share/man/man1/*

      installShellCompletion --zsh --name _artprint share/zsh/functions/_artprint
      installShellCompletion --zsh --name _arttime share/zsh/functions/_arttime

      substituteInPlace $out/share/arttime/src/arttime.zsh \
        --replace-warn "/bin/stty" "${lib.getExe' coreutils "stty"}" \
        --replace-warn "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
        --replace-warn "W: make $etclocaltime" \
          "W: set time.timeZone in your NixOS configuration or make $etclocaltime"

      patchRcPathBash $out/share/arttime/src/arttime.zsh ${lib.makeBinPath runtimeDependencies}

      wrapProgram $out/bin/arttime \
        --set-default TZDIR ${tzdata}/share/zoneinfo \
        --suffix PATH : ${lib.makeBinPath [ zsh ]}

      wrapProgram $out/bin/artprint \
        --suffix PATH : ${
          lib.makeBinPath [
            zsh
            gnused
          ]
        }
    '';

  meta = {
    description = "Clock, timer, time manager and ASCII text-art viewer for the terminal";
    longDescription = ''
      Beauty of text art meets the functionality of a feature-rich clock/timer/pattern-based
      time manager. Arttime brings curated text art to otherwise artless terminal emulators
      of starving developers and other users who can use the terminal. (Arttime CFLAv1 GPLv3)
    '';
    homepage = "https://github.com/poetaman/arttime";
    license = with lib.licenses; [
      gpl3Only
      unfreeRedistributable
    ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.mimvoid ];
  };
})
