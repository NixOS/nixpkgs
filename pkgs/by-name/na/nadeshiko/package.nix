{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  coreutils,
  bc,
  bash,
  ffmpeg,
  mpv,
  makeBinaryWrapper,
  libnotify,
  mediainfo,
  xmlstarlet,
  perlPackages,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nadeshiko";
  version = "2.33.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "deterenkelt";
    repo = "Nadeshiko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-emyIywHU1E9GWwsujzNWQi38nFwqlyjWr7uis01+Ueg=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "SHAREDIR=$(out)/share"
  ];

  postPatch = ''
    substituteInPlace \
      {nadeshiko.sh,nadeshiko-mpv.sh,nadeshiko-do-postponed.sh,lazily_archive_video.sh} \
      --replace-fail \
      'mypath=$(dirname "$(realpath --logical "$0")")' \
      'mypath=${placeholder "out"}'

    substituteInPlace \
      lib/bahelite/modules/core/bootstrap/load_modules.sh \
      --replace-fail '/bin/ls' '${lib.getExe' coreutils "ls"}'
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedBuildInputs = [ bash ];

  propagatedUserEnvPkgs = [
    coreutils
    bc
    ffmpeg
    mpv
    libnotify
    mediainfo
    xmlstarlet
    perlPackages.FileMimeInfo
  ];

  postInstall = ''
    wrapProgram $out/bin/nadeshiko \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs} \
      --set MODULESDIR "$out/lib" \
      --set LIBDIR "$out/lib" \
      --set METACONFDIR "$out/share/metaconf" \
      --set DEFCONFDIR "$out/share/defconf"

    wrapProgram $out/bin/lae \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs} \
      --set MODULESDIR "$out/lib" \
      --set LIBDIR "$out/lib" \
      --set METACONFDIR "$out/share/metaconf" \
      --set DEFCONFDIR "$out/share/defconf"

    wrapProgram $out/bin/nadeshiko-mpv \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs} \
      --set MODULESDIR "$out/lib" \
      --set LIBDIR "$out/lib" \
      --set METACONFDIR "$out/share/metaconf" \
      --set DEFCONFDIR "$out/share/defconf" \
      --set RESDIR "$out/share/res"

    wrapProgram $out/bin/nadeshiko-do-postponed \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs} \
      --set MODULESDIR "$out/lib" \
      --set LIBDIR "$out/lib" \
      --set METACONFDIR "$out/share/metaconf" \
      --set DEFCONFDIR "$out/share/defconf" \
      --set RESDIR "$out/share/res"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cut short videos with ffmpeg";
    homepage = "https://codeberg.org/deterenkelt/Nadeshiko";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "nadeshiko";
    platforms = lib.platforms.all;
  };
})
