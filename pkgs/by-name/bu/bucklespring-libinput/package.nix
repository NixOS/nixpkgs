{
  lib,
  stdenv,
  fetchFromGitHub,

  legacy ? false,
  libinput,

  pkg-config,
  makeWrapper,

  openal,
  alure,
  libxtst,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bucklespring";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "bucklespring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ylZDmK2hmKJShLHMHIziCJ7ERuf3pzNB+vX3HVfEMF8=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openal
    alure
  ]
  ++ lib.optionals legacy [
    libxtst
    libx11
  ]
  ++ lib.optionals (!legacy) [ libinput ];

  makeFlags = lib.optionals (!legacy) [ "libinput=1" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wav
    cp -r $src/wav $out/share/.
    install -D ./buckle.desktop $out/share/applications/buckle.desktop
    install -D ./buckle $out/bin/buckle
    wrapProgram $out/bin/buckle --add-flags "-p $out/share/wav"

    runHook postInstall
  '';

  meta = {
    description = "Nostalgia bucklespring keyboard sound";
    mainProgram = "buckle";
    longDescription = ''
      When built with libinput (wayland or bare console),
      users need to be in the input group to use this:
      <code>users.users.alice.extraGroups = [ "input" ];</code>
    '';
    homepage = "https://github.com/zevv/bucklespring";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
