{
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
  makeWrapper,
  glib,
  gtk3,
  ant,
  jdk,
  libxtst,
  coreutils,
  gnugrep,
  zulu,
  preferZulu ? false,
}:

let
  jre' = (if preferZulu then zulu else jdk).override { enableJavaFX = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "davmail";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "mguessan";
    repo = "davmail";
    tag = finalAttrs.version;
    hash = "sha256-N1+jj+iXRIQ0zxZcZgXPRY+u35ucLXXvh7ofPdrYrVE=";
  };

  buildPhase = ''
    runHook preBuild

    ant prepare-dist
    sed -i -e '/^JAVA_OPTS/d' ./dist/davmail

    runHook postBuild
  '';

  nativeBuildInputs = [
    makeWrapper
    ant
  ];

  buildInputs = [
    jre'
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/davmail
    cp -R ./dist/{lib,davmail{,.jar}} $out/share/davmail
    chmod +x $out/share/davmail/davmail
    makeWrapper $out/share/davmail/davmail $out/bin/davmail \
      --set-default JAVA_OPTS "-Xmx512M -Dsun.net.inetaddr.ttl=60 -Djdk.gtk.version=${lib.versions.major gtk3.version}" \
      --prefix PATH : ${
        lib.makeBinPath [
          jre'
          coreutils
          gnugrep
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          glib
          gtk3
          libxtst
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    homepage = "https://davmail.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      doronbehar
      shymega
    ];
    platforms = lib.platforms.all;
    mainProgram = "davmail";
  };
})
