{
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
  makeWrapper,
  glib,
  gtk2,
  gtk3,
  ant,
  jdk,
  libXtst,
  coreutils,
  gnugrep,
  zulu,
  preferGtk3 ? true,
  preferZulu ? true,
}:

let
  jre' = (if preferZulu then zulu else jdk).override { enableJavaFX = true; };
  gtk' = if preferGtk3 then gtk3 else gtk2;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "davmail";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "mguessan";
    repo = "davmail";
    tag = finalAttrs.version;
    hash = "sha256-dj+7e0b8GcyoDzEWGG1SEMijqRBo1IJUFtgxkt9XNRU=";
  };

  buildPhase = ''
    runHook preBuild

    ant compile prepare-dist
    cp -Rv dist/{lib,davmail{,.jar}} .
    sed -i -e '/^JAVA_OPTS/d' davmail

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
    cp -vR ./{lib,davmail{,.jar}} $out/share/davmail
    chmod +x $out/share/davmail/davmail
    makeWrapper $out/share/davmail/davmail $out/bin/davmail \
      --set-default JAVA_OPTS "-Xmx512M -Dsun.net.inetaddr.ttl=60 -Djdk.gtk.version=${lib.versions.major gtk'.version}" \
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
          gtk'
          libXtst
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    homepage = "https://davmail.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
    mainProgram = "davmail";
  };
})
